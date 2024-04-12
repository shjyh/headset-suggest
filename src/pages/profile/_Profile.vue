<script lang="ts" setup>
import ClientOnly from "@/ClientOnly.vue";
import axios from "axios";
import { ElCard, ElSelect, ElOption } from "element-plus";
import { onMounted, ref } from "vue";

const userInfo = ref<any>({});
const tags = ref<string[]>([]);

onMounted(()=>{
    axios.post("/api/auth//get-userinfo").then(res => {
        userInfo.value = res.data.info;
    });
    axios.post("/api/headphone/tags").then(res=>{
        tags.value = res.data.tags;
    })
})

function saveInfo() {
    axios.post("/api/auth/update-userinfo", userInfo.value);
}

</script>

<template>
    <el-card class="card" shadow="never">
        <template #header>
            <h3>个人信息</h3>
        </template>
        <div class="base-info">
            <div class="item">用户名: {{ userInfo.account }}</div>
            <div class="item">姓名: {{ userInfo.name }}</div>
            <div class="item">性别: {{ userInfo.gender === 1 ? "男" : "女" }}</div>
            <div class="item">年龄: {{ userInfo.age }}</div>
            <div class="item">手机号: {{ userInfo.phone }}</div>
        </div>
        <div class="prefer">
            <div class="sub-title">偏好设置</div>
            <client-only>
                <el-select
                    v-model="userInfo.prefer"
                    multiple placeholder="请选择标签" tag-type="success"
                    class="select" @change="saveInfo"
                >
                    <el-option v-for="tag in tags" :key="tag" :label="tag" :value="tag" />
                </el-select>
            </client-only>
        </div>
    </el-card>
</template>

<style scoped>
.card {
    margin-top: 20px;
}
h3 {
    font-size: 1.2em;
}

.base-info {
    display: flex;
    flex-wrap: wrap;
}
.base-info .item {
    display: block;
    width: 50%;
    padding: 10px 0;
}
.sub-title {
    font-size: 1.1em;
    padding: 20px 0;
}
.prefer {
    margin-top: 20px;
    border-top: 1px solid #eee;
}
.select {
    max-width: 400px;
}
</style>