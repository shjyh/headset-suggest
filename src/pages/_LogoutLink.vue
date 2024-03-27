<script setup lang="ts">
import { ElLink, ElMessageBox } from "element-plus";
import axios from "axios";

async function logout() {
    await ElMessageBox.confirm("确定要退出登录吗?", "退出登录", {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: "warning",
    });
    await axios.post("/api/auth/logout");
    window.location.reload();
}
</script>

<template>
<el-link :underline="false" type="danger" @click="logout">退出登录</el-link>
</template>