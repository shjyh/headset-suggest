<script lang="ts" setup>
import { ElTabs, ElTabPane, ElImage } from "element-plus";

const props = defineProps<{
    detail: any
}>();

const contentImages = props.detail.content.split('\n') as string[];

</script>

<template>
<el-tabs class="content">
    <el-tab-pane label="详情">
        <el-image class="image" v-for="image of contentImages" :key="image" :src="'/assets/' + image" />
    </el-tab-pane>
    <el-tab-pane label="评价">

    </el-tab-pane>
</el-tabs>
</template>

<style scoped>
.content {
    margin-top: 32px;
}
.content :global(.el-tabs__item) {
    font-size: 16px;
}
.image {
    margin: auto;
    display: block;
    width: 750px;
}
</style>