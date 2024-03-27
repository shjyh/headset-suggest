<script setup lang="ts">
import { ElImage, ElScrollbar } from "element-plus"
import { ref } from "vue";

const props = defineProps<{
    images: string[]
}>();

const currentIndex = ref(0);

</script>

<template>
<div class="wrapper">
    <el-image 
        class="image" :src="'/assets/' + props.images[currentIndex]" fit="cover" 
        :preview-src-list="props.images.map(image => '/assets/' + image)" :initial-index="currentIndex" 
        :min-scale="1" :max-scale="2"
    />
    <div class="scroll">
        <el-scrollbar>
            <div class="list">
                <el-image class="item" 
                    v-for="(image, index) of props.images" :key="image" :src="'/assets/' + image" 
                    @click="currentIndex = index"  
                />
            </div>
        </el-scrollbar>
    </div>
</div>
</template>

<style scoped>
.wrapper {
    width: 350px;
}
.image {
    width: 350px;
    height: 350px;
    border-radius: 24px;
}
.list {
    white-space: nowrap;
}
.list > .item {
    display: inline-block;
    vertical-align: middle;
    width: 68px;
    height: 68px;
    border-radius: 4px;
    cursor: pointer;
}
.list > .item + .item {
    margin-left: 8px;
}

.scroll {
    margin-top: 24px;
}
</style>