<script lang="ts" setup>
import axios from 'axios';
import { computed, onMounted, ref } from 'vue';
import { ElTable, ElTableColumn, ElPagination } from "element-plus";

const props = defineProps<{
    uid: number
}>();

const productList = ref<any[]>([]);
const currentPage = ref(1);
onMounted(() => {
    axios.post("/api/manage/user/analyze/" + props.uid).then(res => {
        productList.value = res.data.list
    });
})

const showProductList = computed(() => {
    return productList.value.slice(10 * (currentPage.value - 1), 10 * currentPage.value);
});
</script>

<template>
<el-table class="table" :data="showProductList" max-height="80vh" border>
    <el-table-column prop="id" label="id" width="80px" />
    <el-table-column prop="name" label="商品" />
    <el-table-column prop="visitTimes" label="浏览次数" width="100px">
        <template #default="scope">{{ scope.row.visitTimes || "-" }}</template>
    </el-table-column>
    <el-table-column prop="commentTimes" label="评论次数" width="100px">
        <template #default="scope">{{ scope.row.commentTimes || "-" }}</template>
    </el-table-column>
    <el-table-column prop="inOrder" label="已购买" width="100px">
        <template #default="scope">{{ scope.row.inOrder ? "是" : "-" }}</template>
    </el-table-column>
    <el-table-column prop="isCollected" label="已收藏" width="100px">
        <template #default="scope">{{ scope.row.isCollected ? "是" : "-" }}</template>
    </el-table-column>
    <el-table-column prop="inCart" label="已加车" width="100px">
        <template #default="scope">{{ scope.row.inCart ? "是" : "-" }}</template>
    </el-table-column>
</el-table>
<el-pagination 
    class="pager" background layout="prev, pager, next" 
    :total="productList.length" v-model:current-page="currentPage" 
    :page-size="10" hide-on-single-page
/>
</template>

<style scoped>
.pager {
    margin-top: 24px;
}
</style>