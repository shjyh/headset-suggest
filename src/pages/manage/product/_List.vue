<script setup lang="ts">
import axios from 'axios';
import { computed, onMounted, ref, watch } from 'vue';
import { ElInput, ElTable, ElTableColumn, ElButton, ElImage, ElPagination, ElTag, ElPopover, ElSlider, ElSelect, ElOption } from "element-plus";

const productList = ref<any[]>([]);
const currentPage = ref(1);
async function getList() {
    productList.value = (await axios.post("/api/manage/headphone/list")).data.list
}

const tags = ref<string[]>([]);

onMounted(()=>{
    getList();
    axios.post("/api/headphone/tags").then(res=>{
        tags.value = res.data.tags;
    })
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

function changePopular(p: any, popular: any) {
    axios.post("/api/manage/headphone/update/" + p.id, {
        popular, attrs: p.attrs
    });
}

function updateTags(p: any, tags: string[]) {
    const tagsValue=  tags.join("|").trim();

    const tagsAttrIndex = p.attrs.findIndex((a: any) => a.key === "tags");
    if(tagsAttrIndex > -1) {
        if(tagsValue) {
            if(p.attrs[tagsAttrIndex].value === tagsValue) {
                return;
            }
            
            p.attrs[tagsAttrIndex].value = tagsValue;
        } else {
            p.attrs.splice(tagsAttrIndex, 1);
        }
    } else {
        if(tagsValue) {
            p.attrs.push({key: "tags", value: tagsValue});
        } else {
            return;
        }
    }

    // update remote
    axios.post("/api/manage/headphone/update/" + p.id, {
        popular: p.popular, attrs: p.attrs
    });
}
</script>

<template>
<el-input class="search" type="search" v-model="search" placeholder="请输入搜索关键词" />
<el-table class="table" :data="showProductList" max-height="80vh" border>
    <el-table-column prop="id" label="id" width="80px" />
    <el-table-column label="主图" width="100px">
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
    <el-table-column prop="price" label="价格(￥)" width="100px" />
    <el-table-column label="品牌/型号" width="120px">
        <template #default="scope">
            {{ scope.row.attrs.find((a: any) => a.key === "brand")?.value }} / {{ scope.row.attrs.find((a: any) => a.key === "model")?.value }}
        </template>
    </el-table-column>
    <el-table-column prop="popular" label="流行度(0-100)" width="80px">
        <template #default="scope">
            <el-popover placement="right" trigger="hover" width="100px">
                <template #reference>
                    <el-tag type="success">{{ scope.row.popular }}</el-tag>
                </template>
                <el-slider vertical height="200px" :min="0" :max="100" :step="1" v-model="scope.row.popular" @change="changePopular(scope.row, $event)"></el-slider>
            </el-popover>
        </template>
    </el-table-column>
    <el-table-column label="标签">
        <template #default="scope">
            <el-select 
                :model-value="scope.row.attrs.find((a: any) => a.key === 'tags')?.value.split('|')" 
                multiple placeholder="请选择标签" tag-type="warning"
                @update:model-value="updateTags(scope.row, $event)"
            >
                <el-option v-for="tag in tags" :key="tag" :label="tag" :value="tag" />
            </el-select>
        </template>
    </el-table-column>
    <el-table-column width="80px">
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