<script setup lang="ts">
import axios from "axios";
import { ElDialog, ElForm, ElFormItem, ElInput, ElRadioGroup, ElRadio, ElInputNumber, ElButton, ElMessageBox } from "element-plus";
import type { FormInstance, FormRules } from 'element-plus'
import { reactive, ref, toRaw, unref, watch } from "vue";
const props = defineProps<{
    info: any,
}>();

const emit = defineEmits<{
  (e: 'close'): void;
  (e: "success"): void;
}>()

const info = ref<any>(null);
const ruleFormRef = ref<FormInstance>();

const rules = reactive<FormRules<any>>({
    account: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
        { trigger: 'blur', validator(rule, value, callback) {
            if(info.value.id) {
                callback();
                return;
            }
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
            if(info.value.id) {
                callback();
                return;
            }
            if(value.trim() !== info.value.password.trim()) {
                callback(new Error("输入密码不相同"))
                return;
            }
            callback();
        } }
    ]
})

watch(() => props.info, (newInfo) => {
    if(newInfo !== null) {
        info.value = Object.assign({}, newInfo);
    }
});

async function create() {
    const validPass = await ruleFormRef.value?.validate();
    if(!validPass) return;
    
    const _info: any = Object.assign({}, unref(info));
    delete _info.confirmPassword;

    const { data } = await axios.post("/api/auth/register", _info);

    if(data.code === 0) {
        emit("success");
        emit("close");
    } else {
        await ElMessageBox.alert(data.msg, "创建失败", {
            type: "warning",
            confirmButtonText: "确定"
        })
    }

}

async function update() {
    const validPass = await ruleFormRef.value?.validate();
    if(!validPass) return;

    const _info: any = Object.assign({}, unref(info));
    delete _info.confirmPassword;

    const { data } = await axios.post("/api/manage/user/update", _info);
    if(data.code === 0) {
        emit("success");
        emit("close");
    } else {
        await ElMessageBox.alert(data.msg, "创建失败", {
            type: "warning",
            confirmButtonText: "确定"
        })
    }
}
</script>

<template>
<el-dialog :model-value="!!props.info" @close="emit('close')">
    <template #header>
        <h4>{{ info?.id ? '编辑用户' : '新建用户' }}</h4>
    </template>
    <el-form :model="info" label-width="auto" size="large" ref="ruleFormRef" :rules="rules">
        <el-form-item label="用户名" prop="account">
            <el-input v-model="info.account" placeholder="不小于6位" :disabled="!!info.id" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
            <el-input v-model="info.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="性别">
            <el-radio-group v-model="info.gender">
                <el-radio :value="1" size="large" border>男</el-radio>
                <el-radio :value="2" size="large" border>女</el-radio>
            </el-radio-group>
        </el-form-item>
        <el-form-item label="年龄">
            <el-input-number v-model="info.age" step-strictly :min="18" :max="120" :step="1" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
            <el-input v-model="info.phone" placeholder="请输入手机号" error-message="手机号格式不正确" />
        </el-form-item>
        <el-form-item v-if="!info.id" label="密码" prop="password">
            <el-input type="password" v-model="info.password" placeholder="密码不小于6位" />
        </el-form-item>
        <el-form-item v-if="!info.id" label="确认密码" prop="confirmPassword">
            <el-input type="password" v-model="info.confirmPassword" placeholder="再次输入密码" />
        </el-form-item>
    </el-form>
    <template #footer>
        <el-button type="primary" v-if="!info.id" @click="create">创建</el-button>
        <el-button type="primary" v-else @click="update">更新</el-button>
    </template>
</el-dialog>
</template>

<style scoped>
</style>