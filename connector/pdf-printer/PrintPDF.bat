@ECHO OFF
SETLOCAL

REM ファイルパスの引数が指定されているか確認
IF "%~1"=="" (
    ECHO {"result":"NG: ファイルパスが指定されていません"}
    EXIT /B 1
)

REM 半角スペースを含むファイルパスに対応するためにパラメータを全てファイル名として割り当て
SET "FilePath=%*"

REM ファイルが存在するか確認
IF NOT EXIST "%FilePath%" (
    ECHO {"result":"NG: ファイルが存在しません"}
    EXIT /B 1
)

REM SumatraPDF.exeのパスを設定（適切なパスに変更してください）
SET "SumatraPath=SumatraPDF-3.5.2-64.exe"

REM SumatraPDF.exeが存在するか確認
IF NOT EXIST "%SumatraPath%" (
    ECHO {"result":"NG: SumatraPDF.exeが見つかりません。パスを確認してください"}
    EXIT /B 1
)

REM 拡張子を小文字で取得
FOR %%F IN ("%FilePath%") DO SET "Extension=%%~xF"
SET "Extension=%Extension:~1%"
SET "Extension=%Extension:~0,3%"

REM 小文字に変換（大文字小文字を無視するため /I オプションを使用）
REM 拡張子に応じて印刷処理を行う
IF /I "%Extension%"=="pdf" (
    REM PDFファイルをSumatraPDFで印刷
    "%SumatraPath%" -print-to-default "%FilePath%" >NUL 2>&1
    IF ERRORLEVEL 1 (
        ECHO {"result":"NG: 印刷に失敗しました"}
        EXIT /B 1
    ) ELSE (
        ECHO {"result":"OK"}
        EXIT /B 0
    )
) ELSE (
    ECHO {"result":"NG: このファイルタイプの印刷はサポートされていません"}
    EXIT /B 1
)
