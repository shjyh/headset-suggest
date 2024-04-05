<script setup lang="ts">
import { ElCard, ElButton, ElRow, ElForm, ElFormItem, ElInput, ElLink, ElMessageBox } from "element-plus";
import { reactive, toRaw } from "vue";
import axios from "axios";

const props = defineProps<{
    redirect: string,
    isManage: boolean
}>()

const form = reactive({
    account: "",
    password: ""
});

async function login() {
    const { data } = await axios.post("/api/auth/login", toRaw(form));
    if(data.code === 0) {
        if(props.isManage && !data.info.isAdmin) {
            await axios.post("/api/auth/logout");
            await ElMessageBox.alert("请使用管理员账号登录", "登录失败", {
                type: "warning",
                confirmButtonText: "确定"
            });
            form.account = form.password = "";
            return;
        }
        window.location.replace(props.redirect)
    } else {
        await ElMessageBox.alert(data.msg, "登录失败", {
            type: "warning",
            confirmButtonText: "确定"
        });
        form.account = form.password = "";
    }
}

</script>

<template>
<el-card class="login" shadow="hover" :header=" props.isManage ? '管理后台登录' : '用户名密码登录'">
    <el-form :model="form" label-width="auto" size="large">
        <el-form-item label="用户名">
            <el-input v-model="form.account" placeholder="请输入登录用户名" />
        </el-form-item>
        <el-form-item label="密码">
            <el-input type="password" v-model="form.password" placeholder="请输入登录用户名" />
        </el-form-item>
    </el-form>
    <template #footer>
        <el-row align="middle">
            <el-button class="confirm" type="primary" @click="login">登录</el-button>
            <template v-if="!props.isManage">
                <div class="space"></div>
                <el-link class="link" type="info" :underline="false">忘记密码</el-link>
                <el-link class="link" href="/register" type="success" :underline="false">免费注册</el-link>
            </template>
        </el-row>
    </template>
</el-card>
</template>

<style scoped>
.login {
    width: 400px;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
.space {
    flex: 1;
}
.link + .link {
    margin-left: 20px;
}
</style>