<script setup lang="ts">
import { ElInputNumber, ElButtonGroup, ElButton, ElMessage } from "element-plus";
import { Star, StarFilled } from "@element-plus/icons-vue";
import { ref } from "vue";
import axios from "axios";

const props = defineProps<{
    detail: any;
    isLogin: boolean;
}>();
defineOptions({ inheritAttrs: false })

const num = ref(1);
const loginUrl = import.meta.env.SSR ? "" : "/login?redirect=" + encodeURIComponent(location.pathname + location.search);

function buy() {
    if(!props.isLogin) {
        window.location.href = loginUrl;
        return;
    }
}

function addCart() {
    if(!props.isLogin) {
        window.location.href = loginUrl;
        return;
    }
}

async function collect() {
    if(!props.isLogin) {
        window.location.href = loginUrl;
        return;
    }

    if(isCollected.value) {
        await axios.post("/api/headphone/cancel-collect/" + props.detail.id);
        ElMessage({
            message: "取消收藏",
            type: "success"
        });
        isCollected.value = false
    } else {
        await axios.post("/api/headphone/collect/" + props.detail.id);
        ElMessage({
            message: "收藏成功",
            type: "success"
        });
        isCollected.value = true;
    }

}

const isCollected = ref(props.detail.isCollected == 1);

</script>

<template>
<div class="attr">
    <div class="field">品牌：</div>
    <div class="value">{{ detail.attrs.find((a: any) => a.key === "brand")?.value }}</div>
</div>
<div class="attr">
    <div class="field">型号：</div>
    <div class="value">{{ detail.attrs.find((a: any) => a.key === "model")?.value }}</div>
</div>
<div class="attr">
    <div class="field">数量：</div>
    <div class="value"><el-input-number :min="1" v-model="num" step-strictly :step="1"  /></div>
</div>
<div class="opt">
    <el-button-group size="large">
        <el-button class="buy" @click="buy">立即购买</el-button>
        <el-button class="cart" @click="addCart">加购物车</el-button>
    </el-button-group>
    <div class="collect" :class="{ 'collected': isCollected }" @click="collect">
        <star-filled v-if="isCollected" class="star" />
        <star v-else class="star" />
        <span>{{ isCollected ? "已收藏" : "收藏"}}</span>
    </div>
</div>
</template>

<style scoped>
.attr {
    margin-top: 24px;
}

.field {
    color: #7f7f7f;
    display: inline-block;
    vertical-align: middle;
    width: 4.5em;
}
.value {
    display: inline-block;
    vertical-align: middle;
}

.opt {
    margin-top: 24px;
}

.buy {
    background: linear-gradient(90deg, rgb(255, 119, 0), rgb(255, 73, 0));
    box-shadow: rgba(255, 119, 0, 0.2) 0px 9px 13px 0px;
    color: white;
    border: none;
    border-radius: 100px 0 0 100px;
}
.cart {
    background: linear-gradient(90deg, rgb(255, 203, 0), rgb(255, 148, 2));
    box-shadow: rgba(255, 203, 0, 0.2) 0px 9px 13px 0px;
    color: white;
    border: none;
    border-radius: 0 100px 100px 0;
}

.collect {
    display: inline-block;
    vertical-align: middle;
    font-size: 14px;
    cursor: pointer;
    margin-left: 24px;
}
.collected {
    color: rgb(255, 148, 2)
}
.collect span {
    display: inline-block;
    vertical-align: middle;
    margin-left: 4px;
}


.star {
    width: 16px;
    vertical-align: middle;
}

</style>