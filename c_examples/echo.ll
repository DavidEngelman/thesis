; ModuleID = 'echo.c'
source_filename = "echo.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.infomap = type { i8*, i8* }

@.str = private unnamed_addr constant [23 x i8] c"status == EXIT_SUCCESS\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"echo.c\00", align 1
@__PRETTY_FUNCTION__.usage = private unnamed_addr constant [16 x i8] c"void usage(int)\00", align 1
@.str.2 = private unnamed_addr constant [63 x i8] c"Usage: %s [SHORT-OPTION]... [STRING]...\0A  or:  %s LONG-OPTION\0A\00", align 1
@program_name = external global i8*, align 8
@.str.3 = private unnamed_addr constant [93 x i8] c"Echo the STRING(s) to standard output.\0A\0A  -n             do not output the trailing newline\0A\00", align 1
@stdout = external global %struct._IO_FILE*, align 8
@.str.4 = private unnamed_addr constant [132 x i8] c"  -e             enable interpretation of backslash escapes\0A  -E             disable interpretation of backslash escapes (default)\0A\00", align 1
@.str.5 = private unnamed_addr constant [45 x i8] c"      --help     display this help and exit\0A\00", align 1
@.str.6 = private unnamed_addr constant [54 x i8] c"      --version  output version information and exit\0A\00", align 1
@.str.7 = private unnamed_addr constant [63 x i8] c"\0AIf -e is in effect, the following sequences are recognized:\0A\0A\00", align 1
@.str.8 = private unnamed_addr constant [229 x i8] c"  \5C\5C      backslash\0A  \5Ca      alert (BEL)\0A  \5Cb      backspace\0A  \5Cc      produce no further output\0A  \5Ce      escape\0A  \5Cf      form feed\0A  \5Cn      new line\0A  \5Cr      carriage return\0A  \5Ct      horizontal tab\0A  \5Cv      vertical tab\0A\00", align 1
@.str.9 = private unnamed_addr constant [110 x i8] c"  \5C0NNN   byte with octal value NNN (1 to 3 digits)\0A  \5CxHH    byte with hexadecimal value HH (1 to 2 digits)\0A\00", align 1
@.str.10 = private unnamed_addr constant [191 x i8] c"\0ANOTE: your shell may have its own version of %s, which usually supersedes\0Athe version described here.  Please refer to your shell's documentation\0Afor details about the options it supports.\0A\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"echo\00", align 1
@.str.12 = private unnamed_addr constant [16 x i8] c"POSIXLY_CORRECT\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"-n\00", align 1
@.str.14 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"coreutils\00", align 1
@.str.16 = private unnamed_addr constant [24 x i8] c"/usr/local/share/locale\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c"--help\00", align 1
@.str.18 = private unnamed_addr constant [10 x i8] c"--version\00", align 1
@.str.19 = private unnamed_addr constant [14 x i8] c"GNU coreutils\00", align 1
@Version = external global i8*, align 8
@.str.20 = private unnamed_addr constant [10 x i8] c"Brian Fox\00", align 1
@.str.21 = private unnamed_addr constant [11 x i8] c"Chet Ramey\00", align 1
@emit_ancillary_info.infomap = internal constant [7 x %struct.infomap] [%struct.infomap { i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.22, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.23, i32 0, i32 0) }, %struct.infomap { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.24, i32 0, i32 0) }, %struct.infomap { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.26, i32 0, i32 0) }, %struct.infomap { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.26, i32 0, i32 0) }, %struct.infomap { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.26, i32 0, i32 0) }, %struct.infomap { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.26, i32 0, i32 0) }, %struct.infomap zeroinitializer], align 16
@.str.22 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.23 = private unnamed_addr constant [16 x i8] c"test invocation\00", align 1
@.str.24 = private unnamed_addr constant [22 x i8] c"Multi-call invocation\00", align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"sha224sum\00", align 1
@.str.26 = private unnamed_addr constant [15 x i8] c"sha2 utilities\00", align 1
@.str.27 = private unnamed_addr constant [10 x i8] c"sha256sum\00", align 1
@.str.28 = private unnamed_addr constant [10 x i8] c"sha384sum\00", align 1
@.str.29 = private unnamed_addr constant [10 x i8] c"sha512sum\00", align 1
@.str.30 = private unnamed_addr constant [23 x i8] c"\0A%s online help: <%s>\0A\00", align 1
@.str.31 = private unnamed_addr constant [40 x i8] c"https://www.gnu.org/software/coreutils/\00", align 1
@.str.32 = private unnamed_addr constant [4 x i8] c"en_\00", align 1
@.str.33 = private unnamed_addr constant [71 x i8] c"Report any translation bugs to <https://translationproject.org/team/>\0A\00", align 1
@.str.34 = private unnamed_addr constant [27 x i8] c"Full documentation <%s%s>\0A\00", align 1
@.str.35 = private unnamed_addr constant [51 x i8] c"or available locally via: info '(coreutils) %s%s'\0A\00", align 1
@.str.36 = private unnamed_addr constant [12 x i8] c" invocation\00", align 1

; Function Attrs: noinline noreturn nounwind optnone uwtable
define void @usage(i32) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %6

; <label>:5:                                      ; preds = %1
  br label %7

; <label>:6:                                      ; preds = %1
  call void @__assert_fail(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0), i32 40, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.usage, i32 0, i32 0)) #7
  unreachable

; <label>:7:                                      ; preds = %5
  %8 = call i8* @gettext(i8* getelementptr inbounds ([63 x i8], [63 x i8]* @.str.2, i32 0, i32 0)) #8
  %9 = load i8*, i8** @program_name, align 8
  %10 = load i8*, i8** @program_name, align 8
  %11 = call i32 (i8*, ...) @printf(i8* %8, i8* %9, i8* %10)
  %12 = call i8* @gettext(i8* getelementptr inbounds ([93 x i8], [93 x i8]* @.str.3, i32 0, i32 0)) #8
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %14 = call i32 @fputs_unlocked(i8* %12, %struct._IO_FILE* %13)
  %15 = call i8* @gettext(i8* getelementptr inbounds ([132 x i8], [132 x i8]* @.str.4, i32 0, i32 0)) #8
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %17 = call i32 @fputs_unlocked(i8* %15, %struct._IO_FILE* %16)
  %18 = call i8* @gettext(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.5, i32 0, i32 0)) #8
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %20 = call i32 @fputs_unlocked(i8* %18, %struct._IO_FILE* %19)
  %21 = call i8* @gettext(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.6, i32 0, i32 0)) #8
  %22 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %23 = call i32 @fputs_unlocked(i8* %21, %struct._IO_FILE* %22)
  %24 = call i8* @gettext(i8* getelementptr inbounds ([63 x i8], [63 x i8]* @.str.7, i32 0, i32 0)) #8
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %26 = call i32 @fputs_unlocked(i8* %24, %struct._IO_FILE* %25)
  %27 = call i8* @gettext(i8* getelementptr inbounds ([229 x i8], [229 x i8]* @.str.8, i32 0, i32 0)) #8
  %28 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %29 = call i32 @fputs_unlocked(i8* %27, %struct._IO_FILE* %28)
  %30 = call i8* @gettext(i8* getelementptr inbounds ([110 x i8], [110 x i8]* @.str.9, i32 0, i32 0)) #8
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %32 = call i32 @fputs_unlocked(i8* %30, %struct._IO_FILE* %31)
  %33 = call i8* @gettext(i8* getelementptr inbounds ([191 x i8], [191 x i8]* @.str.10, i32 0, i32 0)) #8
  %34 = call i32 (i8*, ...) @printf(i8* %33, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.11, i32 0, i32 0))
  call void @emit_ancillary_info(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.11, i32 0, i32 0))
  %35 = load i32, i32* %2, align 4
  call void @exit(i32 %35) #7
  unreachable
                                                  ; No predecessors!
  unreachable
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8*, i8*, i32, i8*) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare i8* @gettext(i8*) #3

declare i32 @fputs_unlocked(i8*, %struct._IO_FILE*) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @emit_ancillary_info(i8*) #4 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca %struct.infomap*, align 8
  %5 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %6 = load i8*, i8** %2, align 8
  store i8* %6, i8** %3, align 8
  store %struct.infomap* getelementptr inbounds ([7 x %struct.infomap], [7 x %struct.infomap]* @emit_ancillary_info.infomap, i32 0, i32 0), %struct.infomap** %4, align 8
  br label %7

; <label>:7:                                      ; preds = %22, %1
  %8 = load %struct.infomap*, %struct.infomap** %4, align 8
  %9 = getelementptr inbounds %struct.infomap, %struct.infomap* %8, i32 0, i32 0
  %10 = load i8*, i8** %9, align 8
  %11 = icmp ne i8* %10, null
  br i1 %11, label %12, label %20

; <label>:12:                                     ; preds = %7
  %13 = load i8*, i8** %2, align 8
  %14 = load %struct.infomap*, %struct.infomap** %4, align 8
  %15 = getelementptr inbounds %struct.infomap, %struct.infomap* %14, i32 0, i32 0
  %16 = load i8*, i8** %15, align 8
  %17 = call i32 @strcmp(i8* %13, i8* %16) #9
  %18 = icmp eq i32 %17, 0
  %19 = xor i1 %18, true
  br label %20

; <label>:20:                                     ; preds = %12, %7
  %21 = phi i1 [ false, %7 ], [ %19, %12 ]
  br i1 %21, label %22, label %25

; <label>:22:                                     ; preds = %20
  %23 = load %struct.infomap*, %struct.infomap** %4, align 8
  %24 = getelementptr inbounds %struct.infomap, %struct.infomap* %23, i32 1
  store %struct.infomap* %24, %struct.infomap** %4, align 8
  br label %7

; <label>:25:                                     ; preds = %20
  %26 = load %struct.infomap*, %struct.infomap** %4, align 8
  %27 = getelementptr inbounds %struct.infomap, %struct.infomap* %26, i32 0, i32 1
  %28 = load i8*, i8** %27, align 8
  %29 = icmp ne i8* %28, null
  br i1 %29, label %30, label %34

; <label>:30:                                     ; preds = %25
  %31 = load %struct.infomap*, %struct.infomap** %4, align 8
  %32 = getelementptr inbounds %struct.infomap, %struct.infomap* %31, i32 0, i32 1
  %33 = load i8*, i8** %32, align 8
  store i8* %33, i8** %3, align 8
  br label %34

; <label>:34:                                     ; preds = %30, %25
  %35 = call i8* @gettext(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.30, i32 0, i32 0)) #8
  %36 = call i32 (i8*, ...) @printf(i8* %35, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.19, i32 0, i32 0), i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.31, i32 0, i32 0))
  %37 = call i8* @setlocale(i32 5, i8* null) #8
  store i8* %37, i8** %5, align 8
  %38 = load i8*, i8** %5, align 8
  %39 = icmp ne i8* %38, null
  br i1 %39, label %40, label %48

; <label>:40:                                     ; preds = %34
  %41 = load i8*, i8** %5, align 8
  %42 = call i32 @strncmp(i8* %41, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0), i64 3) #9
  %43 = icmp ne i32 %42, 0
  br i1 %43, label %44, label %48

; <label>:44:                                     ; preds = %40
  %45 = call i8* @gettext(i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.33, i32 0, i32 0)) #8
  %46 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %47 = call i32 @fputs_unlocked(i8* %45, %struct._IO_FILE* %46)
  br label %48

; <label>:48:                                     ; preds = %44, %40, %34
  %49 = call i8* @gettext(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.34, i32 0, i32 0)) #8
  %50 = load i8*, i8** %2, align 8
  %51 = call i32 (i8*, ...) @printf(i8* %49, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.31, i32 0, i32 0), i8* %50)
  %52 = call i8* @gettext(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.35, i32 0, i32 0)) #8
  %53 = load i8*, i8** %3, align 8
  %54 = load i8*, i8** %3, align 8
  %55 = load i8*, i8** %2, align 8
  %56 = icmp eq i8* %54, %55
  %57 = zext i1 %56 to i64
  %58 = select i1 %56, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.36, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.14, i32 0, i32 0)
  %59 = call i32 (i8*, ...) @printf(i8* %52, i8* %53, i8* %58)
  ret void
}

; Function Attrs: noreturn nounwind
declare void @exit(i32) #1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main(i32, i8**) #4 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i8, align 1
  %7 = alloca i8, align 1
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i8*, align 8
  %13 = alloca i8, align 1
  %14 = alloca i8, align 1
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i8 1, i8* %6, align 1
  %15 = call i8* @getenv(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.12, i32 0, i32 0)) #8
  %16 = icmp ne i8* %15, null
  %17 = zext i1 %16 to i8
  store i8 %17, i8* %7, align 1
  %18 = load i8, i8* %7, align 1
  %19 = trunc i8 %18 to i1
  br i1 %19, label %20, label %31

; <label>:20:                                     ; preds = %2
  %21 = load i32, i32* %4, align 4
  %22 = icmp slt i32 1, %21
  br i1 %22, label %23, label %29

; <label>:23:                                     ; preds = %20
  %24 = load i8**, i8*** %5, align 8
  %25 = getelementptr inbounds i8*, i8** %24, i64 1
  %26 = load i8*, i8** %25, align 8
  %27 = call i32 @strcmp(i8* %26, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.13, i32 0, i32 0)) #9
  %28 = icmp eq i32 %27, 0
  br label %29

; <label>:29:                                     ; preds = %23, %20
  %30 = phi i1 [ false, %20 ], [ %28, %23 ]
  br label %31

; <label>:31:                                     ; preds = %29, %2
  %32 = phi i1 [ true, %2 ], [ %30, %29 ]
  %33 = zext i1 %32 to i8
  store i8 %33, i8* %8, align 1
  store i8 0, i8* %9, align 1
  %34 = load i8**, i8*** %5, align 8
  %35 = getelementptr inbounds i8*, i8** %34, i64 0
  %36 = load i8*, i8** %35, align 8
  call void @set_program_name(i8* %36)
  %37 = call i8* @setlocale(i32 6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.14, i32 0, i32 0)) #8
  %38 = call i8* @bindtextdomain(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.16, i32 0, i32 0)) #8
  %39 = call i8* @textdomain(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0)) #8
  %40 = call i32 @atexit(void ()* @close_stdout) #8
  %41 = load i8, i8* %8, align 1
  %42 = trunc i8 %41 to i1
  br i1 %42, label %43, label %63

; <label>:43:                                     ; preds = %31
  %44 = load i32, i32* %4, align 4
  %45 = icmp eq i32 %44, 2
  br i1 %45, label %46, label %63

; <label>:46:                                     ; preds = %43
  %47 = load i8**, i8*** %5, align 8
  %48 = getelementptr inbounds i8*, i8** %47, i64 1
  %49 = load i8*, i8** %48, align 8
  %50 = call i32 @strcmp(i8* %49, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.17, i32 0, i32 0)) #9
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %52, label %53

; <label>:52:                                     ; preds = %46
  call void @usage(i32 0) #10
  unreachable

; <label>:53:                                     ; preds = %46
  %54 = load i8**, i8*** %5, align 8
  %55 = getelementptr inbounds i8*, i8** %54, i64 1
  %56 = load i8*, i8** %55, align 8
  %57 = call i32 @strcmp(i8* %56, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.18, i32 0, i32 0)) #9
  %58 = icmp eq i32 %57, 0
  br i1 %58, label %59, label %62

; <label>:59:                                     ; preds = %53
  %60 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %61 = load i8*, i8** @Version, align 8
  call void (%struct._IO_FILE*, i8*, i8*, i8*, ...) @version_etc(%struct._IO_FILE* %60, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.19, i32 0, i32 0), i8* %61, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.20, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.21, i32 0, i32 0), i8* null)
  store i32 0, i32* %3, align 4
  br label %324

; <label>:62:                                     ; preds = %53
  br label %63

; <label>:63:                                     ; preds = %62, %43, %31
  %64 = load i32, i32* %4, align 4
  %65 = add nsw i32 %64, -1
  store i32 %65, i32* %4, align 4
  %66 = load i8**, i8*** %5, align 8
  %67 = getelementptr inbounds i8*, i8** %66, i32 1
  store i8** %67, i8*** %5, align 8
  %68 = load i8, i8* %8, align 1
  %69 = trunc i8 %68 to i1
  br i1 %69, label %70, label %130

; <label>:70:                                     ; preds = %63
  br label %71

; <label>:71:                                     ; preds = %124, %70
  %72 = load i32, i32* %4, align 4
  %73 = icmp sgt i32 %72, 0
  br i1 %73, label %74, label %81

; <label>:74:                                     ; preds = %71
  %75 = load i8**, i8*** %5, align 8
  %76 = getelementptr inbounds i8*, i8** %75, i64 0
  %77 = load i8*, i8** %76, align 8
  %78 = load i8, i8* %77, align 1
  %79 = sext i8 %78 to i32
  %80 = icmp eq i32 %79, 45
  br label %81

; <label>:81:                                     ; preds = %74, %71
  %82 = phi i1 [ false, %71 ], [ %80, %74 ]
  br i1 %82, label %83, label %129

; <label>:83:                                     ; preds = %81
  %84 = load i8**, i8*** %5, align 8
  %85 = getelementptr inbounds i8*, i8** %84, i64 0
  %86 = load i8*, i8** %85, align 8
  %87 = getelementptr inbounds i8, i8* %86, i64 1
  store i8* %87, i8** %10, align 8
  store i64 0, i64* %11, align 8
  br label %88

; <label>:88:                                     ; preds = %103, %83
  %89 = load i8*, i8** %10, align 8
  %90 = load i64, i64* %11, align 8
  %91 = getelementptr inbounds i8, i8* %89, i64 %90
  %92 = load i8, i8* %91, align 1
  %93 = icmp ne i8 %92, 0
  br i1 %93, label %94, label %106

; <label>:94:                                     ; preds = %88
  %95 = load i8*, i8** %10, align 8
  %96 = load i64, i64* %11, align 8
  %97 = getelementptr inbounds i8, i8* %95, i64 %96
  %98 = load i8, i8* %97, align 1
  %99 = sext i8 %98 to i32
  switch i32 %99, label %101 [
    i32 101, label %100
    i32 69, label %100
    i32 110, label %100
  ]

; <label>:100:                                    ; preds = %94, %94, %94
  br label %102

; <label>:101:                                    ; preds = %94
  br label %131

; <label>:102:                                    ; preds = %100
  br label %103

; <label>:103:                                    ; preds = %102
  %104 = load i64, i64* %11, align 8
  %105 = add i64 %104, 1
  store i64 %105, i64* %11, align 8
  br label %88

; <label>:106:                                    ; preds = %88
  %107 = load i64, i64* %11, align 8
  %108 = icmp eq i64 %107, 0
  br i1 %108, label %109, label %110

; <label>:109:                                    ; preds = %106
  br label %131

; <label>:110:                                    ; preds = %106
  br label %111

; <label>:111:                                    ; preds = %123, %110
  %112 = load i8*, i8** %10, align 8
  %113 = load i8, i8* %112, align 1
  %114 = icmp ne i8 %113, 0
  br i1 %114, label %115, label %124

; <label>:115:                                    ; preds = %111
  %116 = load i8*, i8** %10, align 8
  %117 = getelementptr inbounds i8, i8* %116, i32 1
  store i8* %117, i8** %10, align 8
  %118 = load i8, i8* %116, align 1
  %119 = sext i8 %118 to i32
  switch i32 %119, label %123 [
    i32 101, label %120
    i32 69, label %121
    i32 110, label %122
  ]

; <label>:120:                                    ; preds = %115
  store i8 1, i8* %9, align 1
  br label %123

; <label>:121:                                    ; preds = %115
  store i8 0, i8* %9, align 1
  br label %123

; <label>:122:                                    ; preds = %115
  store i8 0, i8* %6, align 1
  br label %123

; <label>:123:                                    ; preds = %115, %122, %121, %120
  br label %111

; <label>:124:                                    ; preds = %111
  %125 = load i32, i32* %4, align 4
  %126 = add nsw i32 %125, -1
  store i32 %126, i32* %4, align 4
  %127 = load i8**, i8*** %5, align 8
  %128 = getelementptr inbounds i8*, i8** %127, i32 1
  store i8** %128, i8*** %5, align 8
  br label %71

; <label>:129:                                    ; preds = %81
  br label %130

; <label>:130:                                    ; preds = %129, %63
  br label %131

; <label>:131:                                    ; preds = %130, %109, %101
  %132 = load i8, i8* %9, align 1
  %133 = trunc i8 %132 to i1
  br i1 %133, label %137, label %134

; <label>:134:                                    ; preds = %131
  %135 = load i8, i8* %7, align 1
  %136 = trunc i8 %135 to i1
  br i1 %136, label %137, label %298

; <label>:137:                                    ; preds = %134, %131
  br label %138

; <label>:138:                                    ; preds = %296, %137
  %139 = load i32, i32* %4, align 4
  %140 = icmp sgt i32 %139, 0
  br i1 %140, label %141, label %297

; <label>:141:                                    ; preds = %138
  %142 = load i8**, i8*** %5, align 8
  %143 = getelementptr inbounds i8*, i8** %142, i64 0
  %144 = load i8*, i8** %143, align 8
  store i8* %144, i8** %12, align 8
  br label %145

; <label>:145:                                    ; preds = %283, %141
  %146 = load i8*, i8** %12, align 8
  %147 = getelementptr inbounds i8, i8* %146, i32 1
  store i8* %147, i8** %12, align 8
  %148 = load i8, i8* %146, align 1
  store i8 %148, i8* %13, align 1
  %149 = icmp ne i8 %148, 0
  br i1 %149, label %150, label %287

; <label>:150:                                    ; preds = %145
  %151 = load i8, i8* %13, align 1
  %152 = zext i8 %151 to i32
  %153 = icmp eq i32 %152, 92
  br i1 %153, label %154, label %283

; <label>:154:                                    ; preds = %150
  %155 = load i8*, i8** %12, align 8
  %156 = load i8, i8* %155, align 1
  %157 = sext i8 %156 to i32
  %158 = icmp ne i32 %157, 0
  br i1 %158, label %159, label %283

; <label>:159:                                    ; preds = %154
  %160 = load i8*, i8** %12, align 8
  %161 = getelementptr inbounds i8, i8* %160, i32 1
  store i8* %161, i8** %12, align 8
  %162 = load i8, i8* %160, align 1
  store i8 %162, i8* %13, align 1
  %163 = zext i8 %162 to i32
  switch i32 %163, label %280 [
    i32 97, label %164
    i32 98, label %165
    i32 99, label %166
    i32 101, label %167
    i32 102, label %168
    i32 110, label %169
    i32 114, label %170
    i32 116, label %171
    i32 118, label %172
    i32 120, label %173
    i32 48, label %216
    i32 49, label %231
    i32 50, label %231
    i32 51, label %231
    i32 52, label %231
    i32 53, label %231
    i32 54, label %231
    i32 55, label %231
    i32 92, label %278
  ]

; <label>:164:                                    ; preds = %159
  store i8 7, i8* %13, align 1
  br label %282

; <label>:165:                                    ; preds = %159
  store i8 8, i8* %13, align 1
  br label %282

; <label>:166:                                    ; preds = %159
  store i32 0, i32* %3, align 4
  br label %324

; <label>:167:                                    ; preds = %159
  store i8 27, i8* %13, align 1
  br label %282

; <label>:168:                                    ; preds = %159
  store i8 12, i8* %13, align 1
  br label %282

; <label>:169:                                    ; preds = %159
  store i8 10, i8* %13, align 1
  br label %282

; <label>:170:                                    ; preds = %159
  store i8 13, i8* %13, align 1
  br label %282

; <label>:171:                                    ; preds = %159
  store i8 9, i8* %13, align 1
  br label %282

; <label>:172:                                    ; preds = %159
  store i8 11, i8* %13, align 1
  br label %282

; <label>:173:                                    ; preds = %159
  %174 = load i8*, i8** %12, align 8
  %175 = load i8, i8* %174, align 1
  store i8 %175, i8* %14, align 1
  %176 = call i16** @__ctype_b_loc() #11
  %177 = load i16*, i16** %176, align 8
  %178 = load i8, i8* %14, align 1
  %179 = zext i8 %178 to i32
  %180 = sext i32 %179 to i64
  %181 = getelementptr inbounds i16, i16* %177, i64 %180
  %182 = load i16, i16* %181, align 2
  %183 = zext i16 %182 to i32
  %184 = and i32 %183, 4096
  %185 = icmp ne i32 %184, 0
  br i1 %185, label %187, label %186

; <label>:186:                                    ; preds = %173
  br label %279

; <label>:187:                                    ; preds = %173
  %188 = load i8*, i8** %12, align 8
  %189 = getelementptr inbounds i8, i8* %188, i32 1
  store i8* %189, i8** %12, align 8
  %190 = load i8, i8* %14, align 1
  %191 = call i32 @hextobin(i8 zeroext %190)
  %192 = trunc i32 %191 to i8
  store i8 %192, i8* %13, align 1
  %193 = load i8*, i8** %12, align 8
  %194 = load i8, i8* %193, align 1
  store i8 %194, i8* %14, align 1
  %195 = call i16** @__ctype_b_loc() #11
  %196 = load i16*, i16** %195, align 8
  %197 = load i8, i8* %14, align 1
  %198 = zext i8 %197 to i32
  %199 = sext i32 %198 to i64
  %200 = getelementptr inbounds i16, i16* %196, i64 %199
  %201 = load i16, i16* %200, align 2
  %202 = zext i16 %201 to i32
  %203 = and i32 %202, 4096
  %204 = icmp ne i32 %203, 0
  br i1 %204, label %205, label %215

; <label>:205:                                    ; preds = %187
  %206 = load i8*, i8** %12, align 8
  %207 = getelementptr inbounds i8, i8* %206, i32 1
  store i8* %207, i8** %12, align 8
  %208 = load i8, i8* %13, align 1
  %209 = zext i8 %208 to i32
  %210 = mul nsw i32 %209, 16
  %211 = load i8, i8* %14, align 1
  %212 = call i32 @hextobin(i8 zeroext %211)
  %213 = add nsw i32 %210, %212
  %214 = trunc i32 %213 to i8
  store i8 %214, i8* %13, align 1
  br label %215

; <label>:215:                                    ; preds = %205, %187
  br label %282

; <label>:216:                                    ; preds = %159
  store i8 0, i8* %13, align 1
  %217 = load i8*, i8** %12, align 8
  %218 = load i8, i8* %217, align 1
  %219 = sext i8 %218 to i32
  %220 = icmp sle i32 48, %219
  br i1 %220, label %221, label %226

; <label>:221:                                    ; preds = %216
  %222 = load i8*, i8** %12, align 8
  %223 = load i8, i8* %222, align 1
  %224 = sext i8 %223 to i32
  %225 = icmp sle i32 %224, 55
  br i1 %225, label %227, label %226

; <label>:226:                                    ; preds = %221, %216
  br label %282

; <label>:227:                                    ; preds = %221
  %228 = load i8*, i8** %12, align 8
  %229 = getelementptr inbounds i8, i8* %228, i32 1
  store i8* %229, i8** %12, align 8
  %230 = load i8, i8* %228, align 1
  store i8 %230, i8* %13, align 1
  br label %231

; <label>:231:                                    ; preds = %159, %159, %159, %159, %159, %159, %159, %227
  %232 = load i8, i8* %13, align 1
  %233 = zext i8 %232 to i32
  %234 = sub nsw i32 %233, 48
  %235 = trunc i32 %234 to i8
  store i8 %235, i8* %13, align 1
  %236 = load i8*, i8** %12, align 8
  %237 = load i8, i8* %236, align 1
  %238 = sext i8 %237 to i32
  %239 = icmp sle i32 48, %238
  br i1 %239, label %240, label %256

; <label>:240:                                    ; preds = %231
  %241 = load i8*, i8** %12, align 8
  %242 = load i8, i8* %241, align 1
  %243 = sext i8 %242 to i32
  %244 = icmp sle i32 %243, 55
  br i1 %244, label %245, label %256

; <label>:245:                                    ; preds = %240
  %246 = load i8, i8* %13, align 1
  %247 = zext i8 %246 to i32
  %248 = mul nsw i32 %247, 8
  %249 = load i8*, i8** %12, align 8
  %250 = getelementptr inbounds i8, i8* %249, i32 1
  store i8* %250, i8** %12, align 8
  %251 = load i8, i8* %249, align 1
  %252 = sext i8 %251 to i32
  %253 = sub nsw i32 %252, 48
  %254 = add nsw i32 %248, %253
  %255 = trunc i32 %254 to i8
  store i8 %255, i8* %13, align 1
  br label %256

; <label>:256:                                    ; preds = %245, %240, %231
  %257 = load i8*, i8** %12, align 8
  %258 = load i8, i8* %257, align 1
  %259 = sext i8 %258 to i32
  %260 = icmp sle i32 48, %259
  br i1 %260, label %261, label %277

; <label>:261:                                    ; preds = %256
  %262 = load i8*, i8** %12, align 8
  %263 = load i8, i8* %262, align 1
  %264 = sext i8 %263 to i32
  %265 = icmp sle i32 %264, 55
  br i1 %265, label %266, label %277

; <label>:266:                                    ; preds = %261
  %267 = load i8, i8* %13, align 1
  %268 = zext i8 %267 to i32
  %269 = mul nsw i32 %268, 8
  %270 = load i8*, i8** %12, align 8
  %271 = getelementptr inbounds i8, i8* %270, i32 1
  store i8* %271, i8** %12, align 8
  %272 = load i8, i8* %270, align 1
  %273 = sext i8 %272 to i32
  %274 = sub nsw i32 %273, 48
  %275 = add nsw i32 %269, %274
  %276 = trunc i32 %275 to i8
  store i8 %276, i8* %13, align 1
  br label %277

; <label>:277:                                    ; preds = %266, %261, %256
  br label %282

; <label>:278:                                    ; preds = %159
  br label %282

; <label>:279:                                    ; preds = %186
  br label %280

; <label>:280:                                    ; preds = %159, %279
  %281 = call i32 @putchar_unlocked(i32 92)
  br label %282

; <label>:282:                                    ; preds = %280, %278, %277, %226, %215, %172, %171, %170, %169, %168, %167, %165, %164
  br label %283

; <label>:283:                                    ; preds = %282, %154, %150
  %284 = load i8, i8* %13, align 1
  %285 = zext i8 %284 to i32
  %286 = call i32 @putchar_unlocked(i32 %285)
  br label %145

; <label>:287:                                    ; preds = %145
  %288 = load i32, i32* %4, align 4
  %289 = add nsw i32 %288, -1
  store i32 %289, i32* %4, align 4
  %290 = load i8**, i8*** %5, align 8
  %291 = getelementptr inbounds i8*, i8** %290, i32 1
  store i8** %291, i8*** %5, align 8
  %292 = load i32, i32* %4, align 4
  %293 = icmp sgt i32 %292, 0
  br i1 %293, label %294, label %296

; <label>:294:                                    ; preds = %287
  %295 = call i32 @putchar_unlocked(i32 32)
  br label %296

; <label>:296:                                    ; preds = %294, %287
  br label %138

; <label>:297:                                    ; preds = %138
  br label %318

; <label>:298:                                    ; preds = %134
  br label %299

; <label>:299:                                    ; preds = %316, %298
  %300 = load i32, i32* %4, align 4
  %301 = icmp sgt i32 %300, 0
  br i1 %301, label %302, label %317

; <label>:302:                                    ; preds = %299
  %303 = load i8**, i8*** %5, align 8
  %304 = getelementptr inbounds i8*, i8** %303, i64 0
  %305 = load i8*, i8** %304, align 8
  %306 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %307 = call i32 @fputs_unlocked(i8* %305, %struct._IO_FILE* %306)
  %308 = load i32, i32* %4, align 4
  %309 = add nsw i32 %308, -1
  store i32 %309, i32* %4, align 4
  %310 = load i8**, i8*** %5, align 8
  %311 = getelementptr inbounds i8*, i8** %310, i32 1
  store i8** %311, i8*** %5, align 8
  %312 = load i32, i32* %4, align 4
  %313 = icmp sgt i32 %312, 0
  br i1 %313, label %314, label %316

; <label>:314:                                    ; preds = %302
  %315 = call i32 @putchar_unlocked(i32 32)
  br label %316

; <label>:316:                                    ; preds = %314, %302
  br label %299

; <label>:317:                                    ; preds = %299
  br label %318

; <label>:318:                                    ; preds = %317, %297
  %319 = load i8, i8* %6, align 1
  %320 = trunc i8 %319 to i1
  br i1 %320, label %321, label %323

; <label>:321:                                    ; preds = %318
  %322 = call i32 @putchar_unlocked(i32 10)
  br label %323

; <label>:323:                                    ; preds = %321, %318
  store i32 0, i32* %3, align 4
  br label %324

; <label>:324:                                    ; preds = %323, %166, %59
  %325 = load i32, i32* %3, align 4
  ret i32 %325
}

; Function Attrs: nounwind
declare i8* @getenv(i8*) #3

; Function Attrs: nounwind readonly
declare i32 @strcmp(i8*, i8*) #5

declare void @set_program_name(i8*) #2

; Function Attrs: nounwind
declare i8* @setlocale(i32, i8*) #3

; Function Attrs: nounwind
declare i8* @bindtextdomain(i8*, i8*) #3

; Function Attrs: nounwind
declare i8* @textdomain(i8*) #3

; Function Attrs: nounwind
declare i32 @atexit(void ()*) #3

declare void @close_stdout() #2

declare void @version_etc(%struct._IO_FILE*, i8*, i8*, i8*, ...) #2

; Function Attrs: nounwind readnone
declare i16** @__ctype_b_loc() #6

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @hextobin(i8 zeroext) #4 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  store i8 %0, i8* %3, align 1
  %4 = load i8, i8* %3, align 1
  %5 = zext i8 %4 to i32
  switch i32 %5, label %6 [
    i32 97, label %10
    i32 65, label %10
    i32 98, label %11
    i32 66, label %11
    i32 99, label %12
    i32 67, label %12
    i32 100, label %13
    i32 68, label %13
    i32 101, label %14
    i32 69, label %14
    i32 102, label %15
    i32 70, label %15
  ]

; <label>:6:                                      ; preds = %1
  %7 = load i8, i8* %3, align 1
  %8 = zext i8 %7 to i32
  %9 = sub nsw i32 %8, 48
  store i32 %9, i32* %2, align 4
  br label %16

; <label>:10:                                     ; preds = %1, %1
  store i32 10, i32* %2, align 4
  br label %16

; <label>:11:                                     ; preds = %1, %1
  store i32 11, i32* %2, align 4
  br label %16

; <label>:12:                                     ; preds = %1, %1
  store i32 12, i32* %2, align 4
  br label %16

; <label>:13:                                     ; preds = %1, %1
  store i32 13, i32* %2, align 4
  br label %16

; <label>:14:                                     ; preds = %1, %1
  store i32 14, i32* %2, align 4
  br label %16

; <label>:15:                                     ; preds = %1, %1
  store i32 15, i32* %2, align 4
  br label %16

; <label>:16:                                     ; preds = %15, %14, %13, %12, %11, %10, %6
  %17 = load i32, i32* %2, align 4
  ret i32 %17
}

declare i32 @putchar_unlocked(i32) #2

; Function Attrs: nounwind readonly
declare i32 @strncmp(i8*, i8*, i64) #5

attributes #0 = { noinline noreturn nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind }
attributes #9 = { nounwind readonly }
attributes #10 = { noreturn }
attributes #11 = { nounwind readnone }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
