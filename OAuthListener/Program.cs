using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Connections;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace OAuthListener
{
    class Program
    {
        static readonly CancellationTokenSource _cts = new();
        static Task Main(string[] args) => 
        WebHost.CreateDefaultBuilder()
        // Prevent status messages being written to stdout
        .SuppressStatusMessages(true)
        // Disable all logging to stdout
        .ConfigureLogging(config => config.ClearProviders())
        // Listen on the port passed to the process.
        .UseKestrel(options => options.ListenLocalhost(int.Parse(args[0])))
        .Configure(app => app.Run(async context =>
        {
            var message = "ERROR: Unable to retrieve authorisation code.";
            if (context.Request.Query.TryGetValue("code", out var code))
            {
                // We received an authorisation code, output it to stdout.
                Console.WriteLine(code);
                message = "Authentication is complete. You can now close the window/tab.";
            }
            await context.Response.WriteAsync(message);
            // Invalidate the cancellation token so the server stops.
            _cts.Cancel();
        })
        )
        .Build()
        // Run asynchronously using the cancellation token to signal when the process should end.
        // This will be awaited by the .NET framework and the process will end when the cancellation token is invalidated.
        .RunAsync(_cts.Token);
    }
}
