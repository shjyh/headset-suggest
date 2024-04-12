<script lang="ts" setup>
import axios from "axios";
import { ElTabs, ElTabPane, ElImage, ElInput, ElButton, ElMessage, ElText } from "element-plus";
import { onMounted, ref } from "vue";

const props = defineProps<{
    detail: any;
    isLogin: boolean;
    loginUrl?: string;
}>();

const contentImages = props.detail.content.split('\n') as string[];

const comments = ref<any[]>([]);

const comment = ref("");

function getComments() {
    axios.post("/api/headphone/list-comment/" + props.detail.id).then(res=>{
        comments.value = res.data.comments;
    });
}

onMounted(()=>{
    getComments();
})

function send() {
    axios.post("/api/headphone/comment/" + props.detail.id, {
        comment: comment.value
    }).then(()=>{
        ElMessage({
            message: "评价成功",
            type: "success"
        });
        comment.value = "";
        getComments();
    });
}

</script>

<template>
<el-tabs class="content">
    <el-tab-pane label="详情">
        <el-image class="image" v-for="image of contentImages" :key="image" :src="'/assets/' + image" />
    </el-tab-pane>
    <el-tab-pane label="评价">
        <div class="comments">
            <div class="comment" v-for="(comment, index) of comments" :key="index">
                <div class="info"><el-text size="large" type="warning">{{ comment.name || comment.account }}</el-text> <el-text size="small" type="info">{{ comment.createAt }}</el-text></div>
                <div class="comment-content">{{ comment.comment }}</div>
            </div>
        </div>
        <div class="form">
            <el-input v-model="comment" class="input" :placeholder="props.isLogin ? '请输入评价' : '登录后输入评价'" :disabled="!props.isLogin" />
            <el-button type="primary" @click="send" :disabled="!props.isLogin">发送</el-button>
        </div>
    </el-tab-pane>
</el-tabs>
</template>

<style scoped>
.content {
    margin-top: 32px;
}
.content :global(.el-tabs__item) {
    font-size: 16px;
}
.image {
    margin: auto;
    display: block;
    width: 750px;
}
.form {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 20px;
}
.input {
    width: 400px;
}
.comment {
    border-bottom: 1px solid #eee;
    padding: 10px 0;
}
.info {
    font-size: 1.2em;
}
.comment-content {
    margin-top: 10px;
}
</style>