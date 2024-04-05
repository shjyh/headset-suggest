<script setup lang="ts">
import { ElInput, ElTabs, ElTabPane, ElBadge, ElAlert, ElText, ElSelect, ElOption } from "element-plus";
import ClientOnly from "@/ClientOnly.vue";
import { Search } from "@element-plus/icons-vue"
import GridProduct from "./_GridProduct.vue";
import { computed, onMounted, ref, watch } from "vue";
import axios from "axios";

const props = defineProps<{
    isLogin: boolean
}>();

const currentTab = ref<"list" | "popular" | "like">("list");

const list = ref<any[]>([]);
const popular = ref<any[]>([]);
const like = ref<any[]>([]);

const tags = ref<string[]>([]);

const filterCondation = ref({
    search: "",
    tags: [],
    minPrice: null,
    maxPrice: null
});

const priceSort = ref<"asc" | "desc" | "default">("default");

function filterList(list: any[]) {
    const c = filterCondation.value;
    const newList = (!c.search.trim() && !c.tags.length && !c.minPrice && !c.maxPrice) ? list : list.filter(item => {
        if(c.search.trim() && (
            !item.name.includes(c.search) ||
            !item.attrs.find((a: any) => a.value.includes(c.search))
        )) return false;
        if(c.minPrice && item.price < c.minPrice) return false;
        if(c.maxPrice && item.price > c.maxPrice) return false;
        if(c.tags.length) {
            const tagsAttr = item.attrs.find((a: any) => a.key === "tags");
            if(!tagsAttr) return false;
            if(!tagsAttr.value) return false;
            const tags = tagsAttr.value.split("|");
            if(!c.tags.every(tag => tags.includes(tag))) return false;
        }
        return true;
    })
    if(priceSort.value === "default") return newList;
    return newList.sort((a: any, b: any) => {
        if(priceSort.value === "asc") return a.price - b.price;
        if(priceSort.value === "desc") return b.price - a.price;
        return 0;
    })
}

onMounted(async ()=>{
    await axios.post("/api/headphone/tags").then(res=>{
        tags.value = res.data.tags;
    })
})

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
            const { data: likeData } = await axios.post("/api/headphone/list-recommendation")
            like.value = likeData.list;
    }
}, { immediate: !import.meta.env.SSR })

const filteredList = computed(() => {
    return filterList(list.value);
});

const filteredPopular = computed(() => {
    return filterList(popular.value);
});

const filteredLike = computed(() => {
    if(!props.isLogin) return [];
    return filterList(like.value);
});

</script>

<template>
    <div class="wrapper">
        <div class="search-bar">
            <el-input class="search" size="large"  type="search"
                :prefix-icon="Search" placeholder="请输入搜索关键词"
                v-model="filterCondation.search"
            />
            <el-text class="filter" type="info">筛选</el-text>
            <client-only>
                <el-select 
                    class="tags"
                    v-model="filterCondation.tags"
                    multiple placeholder="请选择标签" tag-type="warning"
                    size="large"
                >
                    <el-option v-for="tag in tags" :key="tag" :label="tag" :value="tag" />
                </el-select>
            </client-only>
            <el-text class="filter" type="info">价格</el-text>
            <el-input v-model="filterCondation.minPrice" class="price min" placeholder="最低价格" size="large"></el-input> 
            &emsp;-&emsp;
            <el-input v-model="filterCondation.maxPrice" class="price max" placeholder="最高价格" size="large"></el-input>
            <el-text class="filter" type="info">排序</el-text>
            <client-only>
                <el-select class="sort" v-model="priceSort" size="large">
                    <el-option label="默认" value="default" />
                    <el-option label="价格升序" value="asc" />
                    <el-option label="价格降序" value="desc" />
                </el-select>
            </client-only>
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
}
.search {
    width: 240px;
}
.filter {
    margin-left: 24px;
}
.tags {
    width: 240px;
    margin-left: 12px;
}
.sort {
    width: 120px;
    margin-left: 12px;
}
.price {
    width: 120px;
}
.price.min {
    margin-left: 12px;
}

.tabs {
    margin-top: 12px;
}
</style>