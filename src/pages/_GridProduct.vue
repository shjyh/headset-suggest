<script setup lang="ts">
import { ElCard, ElImage, ElText } from "element-plus";
const props = defineProps<{
    list: any[]
}>();

</script>

<template>
<div class="container">
    <a v-for="item in props.list" :key="item.id" class="card" :href="'/product/' + item.id">
        <el-card shadow="hover">
            <div class="card-body">
                <el-image class="image" fit="cover" :src="'/assets/' + item.mainImage" />
                <div class="side">
                    <el-text tag="h3" class="title" :line-clamp="2">{{ item.name }}</el-text>
                    <div class="info">{{ item.attrs.find((a: any) => a.key === "brand")?.value }} / {{ item.attrs.find((a: any) => a.key === "model")?.value }}</div>
                    <el-text tag="div" class="price" type="danger">¥ <span class="price-value">{{ item.price }}</span></el-text>
                </div>
            </div>
        </el-card>
    </a>
    
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