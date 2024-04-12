<script setup lang="ts">
import axios from 'axios';
import { computed, onMounted, ref, watch } from 'vue';
import { ElTable, ElTableColumn, ElPagination, ElInput, ElLink, ElSelect, ElOption } from "element-plus";

const commentList = ref<any[]>([]);
const currentPage = ref(1);
async function getList() {
    commentList.value = (await axios.post("/api/manage/headphone/list-all-comment")).data.list
}

onMounted(()=>{
   getList(); 
})

const allUsers = computed(()=>{
    // 从commentList中聚合所有的uid 及其对应的uname / uaccount
    const uidSet = new Set<number>();
    commentList.value.forEach((item)=>{
        uidSet.add(item.uid);
    })

    return Array.from(uidSet).map((uid)=>{
        const item = commentList.value.find((item)=>item.uid === uid);
        return {
            uid,
            uname: item?.uname,
            uaccount: item?.uaccount
        }
    })
})
const allProducts = computed(()=>{
    // 从commentList中聚合所有的hid 及其对应的hname
    const hidSet = new Set<number>();
    commentList.value.forEach((item)=>{
        hidSet.add(item.hid);
    })

    return Array.from(hidSet).map((hid)=>{
        const item = commentList.value.find((item)=>item.hid === hid);
        return {
            hid,
            hname: item?.hname
        }
    })
});

const search = ref("");
const uid = ref<number>();
const hid = ref<number>();
watch(()=>search.value, ()=>{
    currentPage.value = 1;
})

const filterCommentList = computed(() => {
    return commentList.value.filter(
        item => {
            if(search.value.trim()) {
                if(!item.comment.includes(search.value.trim())) return false;
            }

            if(uid.value) {
                if(item.uid !== uid.value) return false;
            }

            if(hid.value) {
                if(item.hid !== hid.value) return false;
            }
            return true;
        }
    );
});

const showCommentList = computed(() => {
    return filterCommentList.value.slice(10 * (currentPage.value - 1), 10 * currentPage.value);
});

</script>

<template>
<div class="row">
    <el-input class="search" type="search" v-model="search" placeholder="请输入搜索关键词" />
    <el-select class="select" v-model="uid" placeholder="筛选用户" clearable>
        <el-option v-for="user in allUsers" :key="user.uid" :label="user.uname" :value="user.uid" />
    </el-select>
    <el-select class="select" v-model="hid" placeholder="筛选商品" clearable>
        <el-option v-for="p in allProducts" :key="p.hid" :label="p.hname" :value="p.hid" />
    </el-select>
</div>
<el-table class="table" :data="showCommentList" max-height="80vh" border>
    <el-table-column prop="uname" label="姓名" width="80px">
        <template #default="scope">
            <el-link :href="'/manage/user/detail/' + scope.row.uid" :underline="false">{{ scope.row.uname }}</el-link>
        </template>
    </el-table-column>
    <el-table-column prop="uaccount" label="账号" width="80px">
        <template #default="scope">
            <el-link :href="'/manage/user/detail/' + scope.row.uid" :underline="false">{{ scope.row.uaccount }}</el-link>
        </template>
    </el-table-column>
    <el-table-column prop="hname" label="商品" width="200px" />
    <el-table-column prop="comment" label="评论" />
    <el-table-column prop="createAt" label="时间" />
</el-table>
<el-pagination 
    class="pager" background layout="prev, pager, next" 
    :total="filterCommentList.length" v-model:current-page="currentPage" 
    :page-size="10" hide-on-single-page
/>
</template>

<style scoped>
.table, .pager {
    margin-top: 24px;
}
.row {
    display: flex;
    gap: 20px;
}
.search {
    max-width: 200px;
}
.select {
    max-width: 200px;
}
</style>