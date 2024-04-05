import { defineMiddleware } from "astro:middleware";
import { go } from "./proxy/backend";

export const onRequest = defineMiddleware(async (ctx, next) => {
    const pathname = ctx.url.pathname;
    if(pathname.startsWith("/api")) {
        return await next();
    }

    const isLogin  = (await go(ctx.request, "POST", "/auth/is-login")).isLogin;
    const userInfo = isLogin ? (await go(ctx.request, "POST", "/auth/get-userinfo")).info : null;
    const currentPath = ctx.url.pathname + ctx.url.search;

    if(pathname.startsWith("/manage")) {
        if(isLogin && userInfo.isAdmin) {
            ctx.locals.userInfo = userInfo;
            return await next();
        }
        return ctx.redirect("/login?manage=1&redirect=" + encodeURIComponent(currentPath));
    }

    ctx.locals.isLogin = isLogin;
    ctx.locals.userInfo = userInfo;

    if(!pathname.startsWith("/login") && !isLogin) {
        ctx.locals.loginUrl = "/login?redirect=" + encodeURIComponent(currentPath);
    }

    return await next();
});