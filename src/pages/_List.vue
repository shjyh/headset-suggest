<script setup lang="ts">
import { ElInput, ElButton, ElTabs, ElTabPane, ElBadge, ElAlert } from "element-plus";
import { Search } from "@element-plus/icons-vue"
import GridProduct from "./_GridProduct.vue";
import { computed, ref, watch } from "vue";
import axios from "axios";

const props = defineProps<{
    isLogin: boolean
}>();

const currentTab = ref<"list" | "popular" | "like">("list");

const list = ref<any[]>([]);
const popular = ref<any[]>([]);
const like = ref<any[]>([]);

const search = ref("");
const confirmSearch = ref("");

watch(() => currentTab.value, async(currentTab) =>{
    switch(currentTab) {
        case "list":
            if(list.value.length) return;
            const { data } = await axios.post("/api/headphone/list")
            list.value = data.list;
            break;
        case "popular":
            if(popular.value.length) return;
            const { data: popularData } = await axios.post("/api/headphone/list-popular")
            popular.value = popularData.list;
            break;
        case "like":
            if(!props.isLogin) return;
            if(like.value.length) return;
            // @todo
    }
}, { immediate: !import.meta.env.SSR })

const filteredList = computed(() => {
    if(!confirmSearch.value) return list.value;
    const reg = new RegExp(confirmSearch.value, "i");
    return list.value.filter(item => item.name.match(reg));
});

const filteredPopular = computed(() => {
    if(!confirmSearch.value) return popular.value;
    const reg = new RegExp(confirmSearch.value, "i");
    return popular.value.filter(item => item.name.match(reg));
});

const filteredLike = computed(() => {
    if(!props.isLogin) return [];
    if(!confirmSearch.value) return like.value;
    const reg = new RegExp(confirmSearch.value, "i");
    return like.value.filter(item => item.name.match(reg)); 
});

</script>

<template>
    <div class="wrapper">
        <div class="search-bar">
            <el-input class="search" size="large"  type="search"
                :prefix-icon="Search" placeholder="请输入搜索关键词"
                v-model="search" @keydown.enter="confirmSearch = search"
            />
            <el-button class="search-button" type="primary" @click="confirmSearch = search">搜索</el-button>
        </div>
        <el-tabs class="tabs" type="border-card" v-model="currentTab" @tab-change="currentTab = $event as any">
            <el-tab-pane name="list" label="商品列表">
                <GridProduct :list="filteredList" />
            </el-tab-pane>
            <el-tab-pane name="popular" label="最受欢迎">
                <GridProduct :list="filteredPopular" />
            </el-tab-pane>
            <el-tab-pane name="like">
                <template #label>
                    <el-badge value="hot">
                        <span>猜你喜欢</span>
                    </el-badge>
                </template>
                <el-alert v-if="!props.isLogin" title="个性化推荐需要用户登录" type="error" :closable="false"/>
                <template v-else>
                    <GridProduct :list="filteredLike" />
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