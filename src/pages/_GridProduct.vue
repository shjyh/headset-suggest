<script setup lang="ts">
import { ElCard, ElImage, ElText, ElPagination } from "element-plus";
import { computed, ref, watch } from "vue";
const props = defineProps<{
    list: any[]
}>();

const currentPage = ref(1);

const showList = computed(() => props.list.slice(10 * (currentPage.value - 1), 10 * currentPage.value))

watch(() => props.list, ()=>{
    currentPage.value = 1;
})

</script>

<template>
<div class="container">
    <a v-for="item in showList" :key="item.id" class="card" :href="'/product/' + item.id">
        <el-card shadow="hover">
            <div class="card-body">
                <el-image class="image" fit="cover" :src="'/assets/' + item.mainImage" />
                <div class="side">
                    <el-text tag="h3" class="title" :line-clamp="2">{{ item.name }}</el-text>
                    <el-text tag="div" :line-clamp="1" class="info">{{ item.attrs.find((a: any) => a.key === "brand")?.value }} / {{ item.attrs.find((a: any) => a.key === "model")?.value }}</el-text>
                    <el-text tag="div" class="price" type="danger">¥ <span class="price-value">{{ item.price }}</span></el-text>
                </div>
            </div>
        </el-card>
    </a>
    <el-pagination v-model:current-page="currentPage" class="pager" layout="prev, pager, next" :total="props.list.length" :page-size="10" hide-on-single-page />
</div>
</template>

<style scoped>
.container {
    --gap: 20px;
    --col: 2;
    display: flex;
    flex-wrap: wrap;
    gap: var(--gap);
}
.card {
    width: calc((100% - var(--gap) * (var(--col) - 1)) / var(--col));
    cursor: pointer;
    display: block;
    text-decoration: none;
}
.pager {
    width: 100%;
}
.card-body{
    display: flex;
    gap: 12px;
}
.image {
    width: 120px;
    height: 120px;
}

.title {
    font-size: 1.2em;
    font-weight: bold;
    line-height: 1.3;
}

.price {
    margin-top: 24px;
}

.side {
    flex: 1;
}

.info {
    margin-top: 12px;
}

.price-value {
    font-size: 1.5em;
}

</style>