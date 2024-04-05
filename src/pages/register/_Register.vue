<script setup lang="ts">
import { reactive, ref, toRaw } from "vue";
import { ElCard, ElButton, ElRow, ElForm, ElFormItem, ElInput, ElLink, ElRadioGroup, ElRadio, ElInputNumber, ElMessageBox  } from "element-plus";
import type { FormInstance, FormRules } from 'element-plus'
import axios from "axios";

const registerInfo = reactive({
    account: "",
    password: "",
    confirmPassword: "",
    name: "",
    age: 18,
    gender: 1,
    phone: ""
});

const ruleFormRef = ref<FormInstance>();

const rules = reactive<FormRules<typeof registerInfo>>({
    account: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
        { trigger: 'blur', validator(rule, value, callback) {
            if(value.trim().length < 6) {
                callback(new Error("长度不小于6位"))
                return;
            }
            callback();
        } }
    ],
    name: [
        { required: true, message: '请输入姓名', trigger: 'blur' }
    ],
    phone: [
        { required: true, message: '请输入手机号', trigger: 'blur' }
    ],
    password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { trigger: 'blur', validator(rule, value, callback) {
            if(value.trim().length < 6) {
                callback(new Error("长度不小于6位"))
                return;
            }
            callback();
        } }
    ],
    confirmPassword: [
        {  trigger: 'blur', validator(rule, value, callback) {
            if(value.trim() !== registerInfo.password.trim()) {
                callback(new Error("输入密码不相同"))
                return;
            }
            callback();
        } }
    ]
})

async function register() {
    const validPass = await ruleFormRef.value?.validate();
    if(!validPass) return;

    const info: any = Object.assign({}, toRaw(registerInfo));
    delete info.confirmPassword;

    const { data } = await axios.post("/api/auth/register", info);
    
    if(data.code === 0) {
        try{
            await ElMessageBox.confirm("去登录?", "注册成功", {   
                confirmButtonText: '确定',
                cancelButtonText: '回首页',
                type: "success",
            })
            window.location.replace("/login");
        }catch(e) {
            window.location.replace("/");
        }
    } else {
        await ElMessageBox.alert(data.msg, "注册失败", {
            type: "warning",
            confirmButtonText: "确定"
        })
    }
}

</script>

<template>
<el-card class="register" shadow="hover" header="用户注册">
    <el-form :model="registerInfo" label-width="auto" size="large" ref="ruleFormRef" :rules="rules">
        <el-form-item label="用户名" prop="account">
            <el-input v-model="registerInfo.account" placeholder="不小于6位" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
            <el-input v-model="registerInfo.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="性别">
            <el-radio-group v-model="registerInfo.gender">
                <el-radio :value="1" size="large" border>男</el-radio>
                <el-radio :value="2" size="large" border>女</el-radio>
            </el-radio-group>
        </el-form-item>
        <el-form-item label="年龄">
            <el-input-number v-model="registerInfo.age" step-strictly :min="18" :max="120" :step="1" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
            <el-input v-model="registerInfo.phone" placeholder="请输入手机号" error-message="手机号格式不正确" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
            <el-input type="password" v-model="registerInfo.password" placeholder="密码不小于6位" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
            <el-input type="password" v-model="registerInfo.confirmPassword" placeholder="再次输入密码" />
        </el-form-item>
    </el-form>
    <template #footer>
        <el-row align="middle">
            <el-button class="confirm" type="primary" @click="register">注册</el-button>
            <div class="space"></div>
            <el-link class="link" type="info" href="/login" :underline="false">已有账户? 立即登录</el-link>
        </el-row>
    </template>
</el-card>
</template>

<style scoped>
.register {
    width: 600px;
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