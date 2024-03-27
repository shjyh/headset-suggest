import { defineMiddleware } from "astro:middleware";
import { go } from "./proxy/backend";

export const onRequest = defineMiddleware(async (ctx, next) => {
    const pathname = ctx.url.pathname;
    if(pathname.startsWith("/api")) {
        return await next();
    }
    if(pathname.startsWith("/manage")) {
        // manage page
        return await next();
    }

    const { isLogin } = await go(ctx.request, "POST", "/auth/is-login");
    ctx.locals.isLogin = isLogin;

    if(isLogin) {
        const { info } = await go(ctx.request, "POST", "/auth/get-userinfo");
        ctx.locals.userInfo = info
    } else {
        const url = new URL(ctx.url);
        const currentPath = url.pathname + url.search;
        ctx.locals.loginUrl = "/login?redirect=" + encodeURIComponent(currentPath);
    }
    return await next();
});