using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'deno' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'deno'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'deno' {
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('bundle', 'bundle', [CompletionResultType]::ParameterValue, 'Bundle module and dependencies into single file')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate shell completions')
            [CompletionResult]::new('eval', 'eval', [CompletionResultType]::ParameterValue, 'Eval script')
            [CompletionResult]::new('cache', 'cache', [CompletionResultType]::ParameterValue, 'Cache the dependencies')
            [CompletionResult]::new('fmt', 'fmt', [CompletionResultType]::ParameterValue, 'Format source files')
            [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterValue, 'Show info about cache or info related to source file')
            [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install script as an executable')
            [CompletionResult]::new('repl', 'repl', [CompletionResultType]::ParameterValue, 'Read Eval Print Loop')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a program given a filename or url to the module')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'Run tests')
            [CompletionResult]::new('types', 'types', [CompletionResultType]::ParameterValue, 'Print runtime TypeScript declarations')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrade deno executable to given version')
            [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Show documentation for a module')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
            break
        }
        'deno;bundle' {
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--importmap', 'importmap', [CompletionResultType]::ParameterName, 'UNSTABLE: Load import map file')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;completions' {
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;eval' {
            [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'activate inspector on host:port (default: 127.0.0.1:9229)')
            [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'activate inspector on host:port and break at start of user script')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options. For help: --v8-flags=--help')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-T', 'T', [CompletionResultType]::ParameterName, 'Treat eval input as TypeScript')
            [CompletionResult]::new('--ts', 'ts', [CompletionResultType]::ParameterName, 'Treat eval input as TypeScript')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;cache' {
            [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
            [CompletionResult]::new('--importmap', 'importmap', [CompletionResultType]::ParameterName, 'UNSTABLE: Load import map file')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file. Use with --lock.')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;fmt' {
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Check if the source files are formatted.')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;info' {
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;install' {
            [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
            [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
            [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
            [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Executable file name')
            [CompletionResult]::new('--name', 'name', [CompletionResultType]::ParameterName, 'Executable file name')
            [CompletionResult]::new('--root', 'root', [CompletionResultType]::ParameterName, 'Installation root')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
            [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
            [CompletionResult]::new('--allow-plugin', 'allow-plugin', [CompletionResultType]::ParameterName, 'Allow loading plugins')
            [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
            [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Forcefully overwrite existing installation')
            [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Forcefully overwrite existing installation')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;repl' {
            [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'activate inspector on host:port (default: 127.0.0.1:9229)')
            [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'activate inspector on host:port and break at start of user script')
            [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options. For help: --v8-flags=--help')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;run' {
            [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'activate inspector on host:port (default: 127.0.0.1:9229)')
            [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'activate inspector on host:port and break at start of user script')
            [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
            [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
            [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
            [CompletionResult]::new('--importmap', 'importmap', [CompletionResultType]::ParameterName, 'UNSTABLE: Load import map file')
            [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
            [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options. For help: --v8-flags=--help')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Seed Math.random()')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
            [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
            [CompletionResult]::new('--allow-plugin', 'allow-plugin', [CompletionResultType]::ParameterName, 'Allow loading plugins')
            [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
            [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file. Use with --lock.')
            [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;test' {
            [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'activate inspector on host:port (default: 127.0.0.1:9229)')
            [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'activate inspector on host:port and break at start of user script')
            [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
            [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
            [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
            [CompletionResult]::new('--importmap', 'importmap', [CompletionResultType]::ParameterName, 'UNSTABLE: Load import map file')
            [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Load tsconfig.json configuration file')
            [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
            [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options. For help: --v8-flags=--help')
            [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Seed Math.random()')
            [CompletionResult]::new('--filter', 'filter', [CompletionResultType]::ParameterName, 'A pattern to filter the tests to run by')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
            [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
            [CompletionResult]::new('--allow-plugin', 'allow-plugin', [CompletionResultType]::ParameterName, 'Allow loading plugins')
            [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
            [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file. Use with --lock.')
            [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--failfast', 'failfast', [CompletionResultType]::ParameterName, 'Stop on first error')
            [CompletionResult]::new('--allow-none', 'allow-none', [CompletionResultType]::ParameterName, 'Don''t return error code if no test files are found')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;types' {
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;upgrade' {
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'The version to upgrade to')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--dry-run', 'dry-run', [CompletionResultType]::ParameterName, 'Perform all checks without replacing old exe')
            [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Replace current exe even if not out-of-date')
            [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Replace current exe even if not out-of-date')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;doc' {
            [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable APIs')
            [CompletionResult]::new('--json', 'json', [CompletionResultType]::ParameterName, 'Output documentation in JSON format.')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
        'deno;help' {
            [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
