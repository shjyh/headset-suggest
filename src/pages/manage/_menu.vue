<script lang="ts" setup>
import { ElMenu, ElMenuItem, ElIcon } from "element-plus";
import { PieChart, User, Goods } from "@element-plus/icons-vue";
import { computed } from "vue";
import { navigate } from "astro:transitions/client";
import LogoutLink from "../_LogoutLink.vue";

const menus = [
    { label: "Dashboard", icon: PieChart, path: "/" },
    { label: "用户管理", icon: User, path: "/user" },
    { label: "商品管理", icon: Goods, path: "/product" },
]

const activate = computed(() => {
    const pathname = window.location.pathname;
    for(let menu of menus) {
        if(menu.path === "/") continue;
        if(pathname.startsWith("/manage" + menu.path)) {
            return menu.path;
        }
    }
    return "/";
});

function routeTo(menuPath: string) {
    if(menuPath === activate.value) return;
    const path = "/manage" + (menuPath === "/" ? "" : menuPath);
    navigate(path, {
        history: "replace"
    });
}

</script>

<template>
    <el-menu :default-active="activate" @select="routeTo" class="menu" active-text-color="#ffd04b" background-color="#545c64" text-color="#fff">
        <el-menu-item v-for="item of menus" :key="item.path" :index="item.path">
            <el-icon><component :is="item.icon" /></el-icon>
            <span>{{ item.label }}</span>
        </el-menu-item>
        <logout-link class="logout" />
    </el-menu>
</template>

<style scoped>
.menu {
    width: var(--menu-width);
    position: fixed;
    left: 0;
    top: 0;
    height: 100%;
}
.logout {
    position: absolute;
    bottom: 24px;
    left: 24px;
    right: 24px;
    text-align: center;
}
</style>