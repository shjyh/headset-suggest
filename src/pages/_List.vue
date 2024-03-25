<script setup lang="ts">
import { ElInput, ElButton, ElTabs, ElTabPane, ElBadge, ElAlert } from "element-plus";
import { Search } from "@element-plus/icons-vue"

const props = defineProps<{
    isLogin: boolean
}>();


</script>

<template>
    <div class="wrapper">
        <div class="search-bar">
            <el-input class="search" size="large" 
                :prefix-icon="Search" placeholder="请输入搜索关键词"
            />
            <el-button class="search-button" type="primary">搜索</el-button>
        </div>
        <el-tabs class="tabs" type="border-card">
            <el-tab-pane label="商品列表"></el-tab-pane>
            <el-tab-pane label="最受欢迎"></el-tab-pane>
            <el-tab-pane>
                <template #label>
                    <el-badge value="hot">
                        <span>猜你喜欢</span>
                    </el-badge>
                </template>
                <el-alert v-if="!props.isLogin" title="个性化推荐需要用户登录" type="error" :closable="false"/>
                <template v-else>
                </template>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>

<style scoped>
.wrapper {
    padding: 20px 0;
}
.search-bar {
    display: flex;
    align-items: center;
    justify-content: center
}
.search {
    width: 400px;
}
.search-button {
    margin-left: 12px;
}

.tabs {
    margin-top: 12px;
}
</style>