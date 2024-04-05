<script setup lang="ts">
import axios from 'axios';
import { computed, onMounted, ref, watch } from 'vue';
import { ElInput, ElTable, ElTableColumn, ElButton, ElImage, ElPagination, ElTag, ElPopover } from "element-plus";

const productList = ref<any[]>([]);
const currentPage = ref(1);
async function getList() {
    productList.value = (await axios.post("/api/manage/headphone/list")).data.list
}
onMounted(()=>{
    getList();
})
const search = ref("");
watch(()=>search.value, ()=>{
    currentPage.value = 1;
})

const filterProductList = computed(() => {
    if(!search.value.trim()) return productList.value;
    return productList.value.filter(
        item => item.name.includes(search.value) ||
                item.attrs?.find((a: any) => a.value.includes(search.value))
    );
});

const showProductList = computed(() => {
    return filterProductList.value.slice(10 * (currentPage.value - 1), 10 * currentPage.value);
});

function preview(id: number) {
    window.open("/product/" + id, "_blank");
}
</script>

<template>
<el-input class="search" type="search" v-model="search" placeholder="请输入搜索关键词" />
<el-table class="table" :data="showProductList" height="80vh">
    <el-table-column prop="id" label="id" />
    <el-table-column label="主图">
        <template #default="scope">
            <el-image 
                fit="cover" class="image" 
                :src="'/assets/' + scope.row.mainImage" 
                :preview-src-list="['/assets/' + scope.row.mainImage]"
                preview-teleported
            />
        </template>
    </el-table-column>
    <el-table-column prop="name" label="标题" />
    <el-table-column prop="price" label="价格(￥)" />
    <el-table-column label="品牌/型号">
        <template #default="scope">
            {{ scope.row.attrs.find((a: any) => a.key === "brand")?.value }} / {{ scope.row.attrs.find((a: any) => a.key === "model")?.value }}
        </template>
    </el-table-column>
    <el-table-column prop="popular" label="流行度(0-100)" />
    <el-table-column label="标签">
        <template #default="scope">
            <template v-for="tag in scope.row.attrs.find((a: any) => a.key === 'tags')?.value.split('|')" :key="tag">
                <el-tag>{{ tag }}</el-tag>
            </template>
        </template>
    </el-table-column>
    <el-table-column>
        <template #default="scope">
            <el-button link type="primary" @click="preview(scope.row.id)">预览</el-button>
        </template>
    </el-table-column>
</el-table>
<el-pagination 
    class="pager" background layout="prev, pager, next" 
    :total="filterProductList.length" v-model:current-page="currentPage" 
    :page-size="10" hide-on-single-page
/>
</template>

<style scoped>
.table, .pager {
    margin-top: 24px;
}
.image{
    width: 60px;
    height: 60px;
}
.search {
    max-width: 200px;
}
</style>