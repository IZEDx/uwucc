import { copy, copySync } from "fs-extra";
import { join, resolve } from "path";
import * as ts from "typescript";
import * as tstl from "typescript-to-lua";

let _copyStatic = false;
const plugin: tstl.Plugin = {
	/*
	visitors: {
		// Visit string literals, if original transformer returns a string literal, change the string to "bar" instead
		[ts.SyntaxKind.FunctionDeclaration]: (node, context) => {
			// `context` exposes `superTransform*` methods, that can be used to call either the visitor provided by previous
			// plugin, or a standard TypeScriptToLua visitor
			const result = context.superTransformStatements(node);

			context.sourceFile.fileName;

			const curDir = context.options.rootDir + "/";
			const fileName = context.sourceFile.fileName.slice(curDir.length).replaceAll("\\", "/");
			const id = fileName + ":" + node.name?.text;
			for (const assign of result) {
				if (tstl.isAssignmentStatement(assign)) {
					for (const func of assign.right) {
						if (tstl.isFunctionExpression(func)) {
							func.body.statements = [
								tstl.createAssignmentStatement(
									tstl.createIdentifier(
										`_G.__tracetrace["${fileName}"][${context.sourceFile.getLineAndCharacterOfPosition(node.getStart()).line}]`,
									),
									tstl.createIdentifier(`debug.traceback("${id}", 2)`),
								),
								...func.body.statements,
							];
						}
					}
					//console.log(node.name, result);
				}
			}
			//process.exit();
			// Standard visitor for ts.StringLiteral always returns tstl.StringLiteral node
			return result;
		},
	},
	*/
	afterPrint(
		program: ts.Program,
		options: tstl.CompilerOptions,
		emitHost: tstl.EmitHost,
		result: tstl.ProcessedFile[],
	) {
		_copyStatic = true;
		const curDir = options.rootDir + "/";
		for (const file of result) {
			const fileName = file.fileName.slice(curDir.length).replaceAll("\\", "/");
			const subdirs = fileName.split("/").length - 1;
			let output = file.code;
			if (subdirs >= 1) {
				output =
					`package.path = package.path .. ";${"../".repeat(subdirs)}?.lua"\n` + output;
			}
			//output =
			//	`_G.__tracetrace["${fileName}"] = _G.__tracetrace["${fileName}"] or {}\n` + output;
			//output = "_G.__tracetrace = _G.__tracetrace or {}\n" + output;
			//output = `-- ${fileName}\n` + output;
			file.code = output
				.split("\n")
				.map((text, i) => text.replaceAll("%%_LINE_%%", "" + (i - 2)))
				.join("\n");
		}
	},
	afterEmit(program, options, emitHost, result) {
		if (_copyStatic) {
			_copyStatic = false;
			const dir = resolve("./static");
			try {
				copySync(dir, join(options.outDir ?? join(dir, "dist"), "static"), {
					overwrite: false,
					errorOnExist: false,
				});
			} catch (e) {
				console.log(e);
			}
		}
	},
	/*
	moduleResolution(
		moduleIdentifier: string,
		requiringFile: string,
		options: tstl.CompilerOptions,
		emitHost: tstl.EmitHost,
	) {
		const root = options.outDir?.replaceAll("\\", "/").split("/").findLast(Boolean) ?? "";
		const fileName = requiringFile.slice((options.rootDir + "/").length).replaceAll("\\", "/");
		const fileDir = fileName.split("/").slice(0, -1).join("/");
		//console.log(join(root, fileDir, moduleIdentifier));
		return join(root, fileDir, moduleIdentifier);
	},
  */
};

export default plugin;
