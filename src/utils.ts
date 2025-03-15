import { strings } from "./strings";

export const withUserAgentValidation = (
  handler: (c: any) => Promise<Response> | Response,
  // fallbackText: string = strings.defaultUseragentError,
  {
    fallbackText = strings.defaultUseragentError,
  }: { fallbackText?: string } = {}
) => {
  return async (c: any) => {
    const userAgent = c.req.header("User-Agent");

    if (!userAgent?.includes("PowerShell")) {
      return c.text(fallbackText, 200);
    }

    return handler(c);
  };
};
