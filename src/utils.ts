export const withUserAgentValidation = (handler: (c: any) => Promise<Response> | Response) => {
  return async (c: any) => {
    const userAgent = c.req.header('User-Agent');
    
    if (!userAgent?.includes("PowerShell")) {
      return c.text(
        `To run this script, use the following command in PowerShell:

        irm https://winwipe.gergo.cc | iex

        Check the docs at: https://winwipe.gergo.cc/docs`, 
        200
      );
    }
    
    return handler(c);
  };
};