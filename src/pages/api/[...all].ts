import { pass } from "@/proxy/backend";
import type { APIRoute } from "astro";

export const GET: APIRoute = ctx => {
    return pass(ctx.request);
}

export const POST: APIRoute = ctx => {
    return pass(ctx.request);
}