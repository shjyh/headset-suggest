<script lang="ts" setup>
import axios from 'axios';
import { computed, onMounted, ref } from 'vue';
import { ElCard, ElText, ElCheckbox, ElImage, ElInputNumber, ElButton, ElMessageBox, ElLink, ElEmpty } from "element-plus";

const init = ref(false);
const cartItems = ref<any[]>([]);
const selected = ref<number[]>([]);

async function getCartList(initSelect = false) {
    const { data: { list } } = await axios.post("/api/cart/list");
    cartItems.value = list;
    if(initSelect) {
        selected.value = list.map((item: any) => item.id);
    }
}
onMounted(()=>{
    getCartList(true).then(()=>{
        init.value = true;
    });
});

function onNumChange(id: number, num: number) {
    axios.post("/api/cart/update", {
        id, num
    })
}

const totalAmt = computed(() => cartItems.value.filter(item => selected.value.includes(item.id)).reduce((acc, item) => acc + item.price * item.num, 0))

async function submit() {
    const ok = await ElMessageBox.confirm("确定要购买吗?", "模拟下单", {
        
    }).then(() => true).catch(() => false);

    if(!ok) return;

    const { data } = await axios.post("/api/order/create", {
        items: cartItems.value.filter(item => selected.value.includes(item.id)).map((item: any) => ({
            itemId: item.id,
            num: item.num,
            cartId: item.id
        }))
    });

    window.location.href = "/order/detail/" + data.id;
}

async function deleteCartItem(id: number) {
    const ok = await ElMessageBox.confirm("确定要从购物车中删除吗?", "提示", {
        
    }).then(() => true).catch(() => false);

    if(!ok) return;

    axios.post("/api/cart/delete/" + id);
    if(selected.value.includes(id)) {
        selected.value = selected.value.filter(i => i !== id);
    }
    cartItems.value = cartItems.value.filter(item => item.id !== id);
}

</script>

<template>
    <el-card class="cart" shadow="never" v-if="init">
        <template #header>
            <el-text tag="h3">购物车</el-text>
        </template>
        <el-empty v-if="!cartItems.length" description="购物车空空如也" />
        <template v-else>
            <div class="cart-item" v-for="item of cartItems" :key="item.id">
                <el-checkbox :checked="selected.includes(item.id)" @update:model-value="e => selected = e ? selected.concat(item.id) : selected.filter(id => id !== item.id)" size="large" />
                <el-image class="image" :src="'/assets/' + item.itemImage" fit="cover" />
                <div class="info">
                    <el-link :underline="false" class="name" :href="'/product/' + item.itemId">{{ item.itemName }}</el-link>
                    <el-text tag="div" class="price">单价：¥ <span class="price-value">{{ item.price.toFixed(2) }}</span></el-text>
                    <div class="other">
                        <el-input-number class="num" v-model="item.num" :min="1" @change="onNumChange(item.id, $event || 1)" :step="1" step-strictly />
                        <el-text tag="div" type="danger">总价：¥ <span class="price-value">{{ (item.price * item.num).toFixed(2) }}</span></el-text>
                        <el-button text type="info" @click="deleteCartItem(item.id)">从购物车删除</el-button>
                    </div>
                </div>
            </div>
        </template>
        
        <template v-if="cartItems.length" #footer>
            <div class="footer">
                <el-text tag="div" type="danger">总价：¥ <span class="price-value">{{ totalAmt.toFixed(2) }}</span></el-text>
                <el-button type="primary" @click="submit">结算</el-button>
            </div>
        </template>
    </el-card>
</template>

<style scoped>
.cart {
    margin-top: 20px;
}
h3 {
    font-size: 1.3em;
    font-weight: bold;
}
.cart-item {
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 10px 0;
}
.cart-item + .cart-item {
    border-top: 1px solid #eee;
}
.image {
    width: 120px;
    height: 120px;
}
.info {
    align-self: self-start;
}
.name {
    font-size: 1.1em;
}
.price {
    margin-top: 24px;
}
.price-value {
    font-size: 1.5em;
}
.other {
    margin-top: 24px;
    display: flex;
    gap: 20px;
}
.footer {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 20px;
}
</style>