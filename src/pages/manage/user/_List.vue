<script setup lang="ts">
import axios from "axios";
import { computed, onMounted, ref, watch } from "vue";
import { ElTable, ElTableColumn, ElPagination, ElButton, ElInput, ElRow } from "element-plus";
import EditorModal from "./_EditorModal.vue";

const userList = ref<any[]>([]);
const currentPage = ref(1);

async function getList() {
    userList.value = (await axios.post("/api/manage/user/list")).data.list
}

onMounted(()=>{
    getList();
})

const search = ref("");
watch(()=>search.value, ()=>{
    currentPage.value = 1;
})

const filterUserList = computed(() => {
    if(!search.value.trim()) return userList.value;
    return userList.value.filter(item => item.account.includes(search.value) || item.name?.includes(search.value) || item.phone?.includes(search.value));
});

const showUserList = computed(() => {
    return filterUserList.value.slice(10 * (currentPage.value - 1), 10 * currentPage.value);
});

const currentSelect = ref<any>(null);

</script>

<template>
<el-row>
    <el-button class="create" type="primary" @click="currentSelect = {}">新建</el-button>
    <el-input class="search" type="search" v-model="search" placeholder="请输入搜索关键词" />
</el-row>
<el-table class="table" :data="showUserList" stripe border>
    <el-table-column prop="id" label="id" width="80px" />
    <el-table-column prop="account" label="账号" />
    <el-table-column prop="name" label="姓名" />
    <el-table-column prop="phone" label="手机号" />
    <el-table-column label="性别" width="60px" >
        <template #default="scope">
            <template v-if="scope.row.gender === 1">男</template>
            <template v-if="scope.row.gender === 2">女</template>
        </template>
    </el-table-column>
    <el-table-column prop="age" label="年龄" width="80px" />
    <el-table-column label="操作" width="120px">
        <template #default="scope">
            <el-button link type="primary" @click="currentSelect = scope.row">编辑</el-button>
            <el-button link type="primary">数据</el-button>
        </template>
    </el-table-column>
</el-table>
<el-pagination 
    class="pager" background layout="prev, pager, next" 
    :total="filterUserList.length" v-model:current-page="currentPage" 
    :page-size="10" hide-on-single-page
/>
<EditorModal :info="currentSelect" @close="currentSelect = null" @success="getList" />
</template>

<style scoped>
.table, .pager {
    margin-top: 24px;
}

.search {
    flex: 1;
    max-width: 200px;
    margin-left: 24px;
}
</style>