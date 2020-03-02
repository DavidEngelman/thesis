; ModuleID = '../c-ray/c-ray-f-2.ll'
source_filename = "c-ray-f-2.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.vec3 = type { double, double, double }
%struct.sphere = type { %struct.vec3, double, %struct.material, %struct.sphere* }
%struct.material = type { %struct.vec3, double, double }
%struct.camera = type { %struct.vec3, %struct.vec3, double }
%struct.timeval = type { i64, i64 }
%struct.timezone = type { i32, i32 }
%struct.ray = type { %struct.vec3, %struct.vec3 }
%struct.spoint = type { %struct.vec3, %struct.vec3, %struct.vec3, double }

@xres = global i32 800, align 4
@yres = global i32 600, align 4
@aspect = global double 0x3FF55554FBDAD752, align 8
@lnum = global i32 0, align 4
@.str = private unnamed_addr constant [363 x i8] c"Usage: c-ray-f [options]\0A  Reads a scene file from stdin, writes the image to stdout, and stats to stderr.\0A\0AOptions:\0A  -s WxH     where W is the width and H the height of the image\0A  -r <rays>  shoot <rays> rays per pixel (antialiasing)\0A  -i <file>  read from <file> instead of stdin\0A  -o <file>  write to <file> instead of stdout\0A  -h         this help screen\0A\0A\00", align 1
@usage = global i8* getelementptr inbounds ([363 x i8], [363 x i8]* @.str, i32 0, i32 0), align 8
@stdin = external global %struct._IO_FILE*, align 8
@stdout = external global %struct._IO_FILE*, align 8
@.str.1 = private unnamed_addr constant [6 x i8] c"scene\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"rendered_scene\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.5 = private unnamed_addr constant [31 x i8] c"pixel buffer allocation failed\00", align 1
@urand = common global [1024 x %struct.vec3] zeroinitializer, align 16
@irand = common global [1024 x i32] zeroinitializer, align 16
@stderr = external global %struct._IO_FILE*, align 8
@.str.6 = private unnamed_addr constant [48 x i8] c"Rendering took: %lu seconds (%lu milliseconds)\0A\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"P6\0A%d %d\0A255\0A\00", align 1
@obj_list = common global %struct.sphere* null, align 8
@lights = common global [16 x %struct.vec3] zeroinitializer, align 16
@get_primary_ray.j = private unnamed_addr constant %struct.vec3 { double 0.000000e+00, double 1.000000e+00, double 0.000000e+00 }, align 8
@cam = common global %struct.camera zeroinitializer, align 8
@get_sample_pos.sf = internal global double 0.000000e+00, align 8
@.str.8 = private unnamed_addr constant [4 x i8] c" \09\0A\00", align 1
@.str.9 = private unnamed_addr constant [18 x i8] c"unknown type: %c\0A\00", align 1
@get_msec.timeval = internal global %struct.timeval zeroinitializer, align 8
@get_msec.first_timeval = internal global %struct.timeval zeroinitializer, align 8

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct._IO_FILE*, align 8
  %8 = alloca %struct._IO_FILE*, align 8
  store i32 0, i32* %1, align 4
  store i32 1, i32* %6, align 4
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8
  store %struct._IO_FILE* %9, %struct._IO_FILE** %7, align 8
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  store %struct._IO_FILE* %10, %struct._IO_FILE** %8, align 8
  %11 = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store %struct._IO_FILE* %11, %struct._IO_FILE** %7, align 8
  %12 = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store %struct._IO_FILE* %12, %struct._IO_FILE** %8, align 8
  %13 = load i32, i32* @xres, align 4
  %14 = load i32, i32* @yres, align 4
  %15 = mul nsw i32 %13, %14
  %16 = sext i32 %15 to i64
  %17 = mul i64 %16, 4
  %18 = call noalias i8* @malloc(i64 %17) #5
  %19 = bitcast i8* %18 to i32*
  store i32* %19, i32** %5, align 8
  %20 = icmp ne i32* %19, null
  br i1 %20, label %22, label %21

; <label>:21:                                     ; preds = %0
  call void @perror(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.5, i32 0, i32 0))
  store i32 1, i32* %1, align 4
  br label %143

; <label>:22:                                     ; preds = %0
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** %7, align 8
  call void @load_scene(%struct._IO_FILE* %23)
  store i32 0, i32* %2, align 4
  br label %24

; <label>:24:                                     ; preds = %36, %22
  %25 = load i32, i32* %2, align 4
  %26 = icmp slt i32 %25, 1024
  br i1 %26, label %27, label %39

; <label>:27:                                     ; preds = %24
  %28 = call i32 @rand() #5
  %29 = sitofp i32 %28 to double
  %30 = fdiv double %29, 0x41DFFFFFFFC00000
  %31 = fsub double %30, 5.000000e-01
  %32 = load i32, i32* %2, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %33
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %34, i32 0, i32 0
  store double %31, double* %35, align 8
  br label %36

; <label>:36:                                     ; preds = %27
  %37 = load i32, i32* %2, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, i32* %2, align 4
  br label %24

; <label>:39:                                     ; preds = %24
  store i32 0, i32* %2, align 4
  br label %40

; <label>:40:                                     ; preds = %52, %39
  %41 = load i32, i32* %2, align 4
  %42 = icmp slt i32 %41, 1024
  br i1 %42, label %43, label %55

; <label>:43:                                     ; preds = %40
  %44 = call i32 @rand() #5
  %45 = sitofp i32 %44 to double
  %46 = fdiv double %45, 0x41DFFFFFFFC00000
  %47 = fsub double %46, 5.000000e-01
  %48 = load i32, i32* %2, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %49
  %51 = getelementptr inbounds %struct.vec3, %struct.vec3* %50, i32 0, i32 1
  store double %47, double* %51, align 8
  br label %52

; <label>:52:                                     ; preds = %43
  %53 = load i32, i32* %2, align 4
  %54 = add nsw i32 %53, 1
  store i32 %54, i32* %2, align 4
  br label %40

; <label>:55:                                     ; preds = %40
  store i32 0, i32* %2, align 4
  br label %56

; <label>:56:                                     ; preds = %68, %55
  %57 = load i32, i32* %2, align 4
  %58 = icmp slt i32 %57, 1024
  br i1 %58, label %59, label %71

; <label>:59:                                     ; preds = %56
  %60 = call i32 @rand() #5
  %61 = sitofp i32 %60 to double
  %62 = fdiv double %61, 0x41DFFFFFFFC00000
  %63 = fmul double 1.024000e+03, %62
  %64 = fptosi double %63 to i32
  %65 = load i32, i32* %2, align 4
  %66 = sext i32 %65 to i64
  %67 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %66
  store i32 %64, i32* %67, align 4
  br label %68

; <label>:68:                                     ; preds = %59
  %69 = load i32, i32* %2, align 4
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %2, align 4
  br label %56

; <label>:71:                                     ; preds = %56
  %72 = call i64 @get_msec()
  store i64 %72, i64* %4, align 8
  %73 = load i32, i32* @xres, align 4
  %74 = load i32, i32* @yres, align 4
  %75 = load i32*, i32** %5, align 8
  %76 = load i32, i32* %6, align 4
  call void @render(i32 %73, i32 %74, i32* %75, i32 %76)
  %77 = call i64 @get_msec()
  %78 = load i64, i64* %4, align 8
  %79 = sub i64 %77, %78
  store i64 %79, i64* %3, align 8
  %80 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %81 = load i64, i64* %3, align 8
  %82 = udiv i64 %81, 1000
  %83 = load i64, i64* %3, align 8
  %84 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %80, i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.6, i32 0, i32 0), i64 %82, i64 %83)
  %85 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %86 = load i32, i32* @xres, align 4
  %87 = load i32, i32* @yres, align 4
  %88 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %85, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.7, i32 0, i32 0), i32 %86, i32 %87)
  store i32 0, i32* %2, align 4
  br label %89

; <label>:89:                                     ; preds = %123, %71
  %90 = load i32, i32* %2, align 4
  %91 = load i32, i32* @xres, align 4
  %92 = load i32, i32* @yres, align 4
  %93 = mul nsw i32 %91, %92
  %94 = icmp slt i32 %90, %93
  br i1 %94, label %95, label %126

; <label>:95:                                     ; preds = %89
  %96 = load i32*, i32** %5, align 8
  %97 = load i32, i32* %2, align 4
  %98 = sext i32 %97 to i64
  %99 = getelementptr inbounds i32, i32* %96, i64 %98
  %100 = load i32, i32* %99, align 4
  %101 = lshr i32 %100, 16
  %102 = and i32 %101, 255
  %103 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %104 = call i32 @fputc(i32 %102, %struct._IO_FILE* %103)
  %105 = load i32*, i32** %5, align 8
  %106 = load i32, i32* %2, align 4
  %107 = sext i32 %106 to i64
  %108 = getelementptr inbounds i32, i32* %105, i64 %107
  %109 = load i32, i32* %108, align 4
  %110 = lshr i32 %109, 8
  %111 = and i32 %110, 255
  %112 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %113 = call i32 @fputc(i32 %111, %struct._IO_FILE* %112)
  %114 = load i32*, i32** %5, align 8
  %115 = load i32, i32* %2, align 4
  %116 = sext i32 %115 to i64
  %117 = getelementptr inbounds i32, i32* %114, i64 %116
  %118 = load i32, i32* %117, align 4
  %119 = lshr i32 %118, 0
  %120 = and i32 %119, 255
  %121 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %122 = call i32 @fputc(i32 %120, %struct._IO_FILE* %121)
  br label %123

; <label>:123:                                    ; preds = %95
  %124 = load i32, i32* %2, align 4
  %125 = add nsw i32 %124, 1
  store i32 %125, i32* %2, align 4
  br label %89

; <label>:126:                                    ; preds = %89
  %127 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %128 = call i32 @fflush(%struct._IO_FILE* %127)
  %129 = load %struct._IO_FILE*, %struct._IO_FILE** %7, align 8
  %130 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8
  %131 = icmp ne %struct._IO_FILE* %129, %130
  br i1 %131, label %132, label %135

; <label>:132:                                    ; preds = %126
  %133 = load %struct._IO_FILE*, %struct._IO_FILE** %7, align 8
  %134 = call i32 @fclose(%struct._IO_FILE* %133)
  br label %135

; <label>:135:                                    ; preds = %132, %126
  %136 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %137 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %138 = icmp ne %struct._IO_FILE* %136, %137
  br i1 %138, label %139, label %142

; <label>:139:                                    ; preds = %135
  %140 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %141 = call i32 @fclose(%struct._IO_FILE* %140)
  br label %142

; <label>:142:                                    ; preds = %139, %135
  store i32 0, i32* %1, align 4
  br label %143

; <label>:143:                                    ; preds = %142, %21
  %144 = load i32, i32* %1, align 4
  ret i32 %144
}

declare %struct._IO_FILE* @fopen(i8*, i8*) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #2

declare void @perror(i8*) #1

; Function Attrs: noinline nounwind optnone uwtable
define void @load_scene(%struct._IO_FILE*) #0 {
  %2 = alloca %struct._IO_FILE*, align 8
  %3 = alloca [256 x i8], align 16
  %4 = alloca i8*, align 8
  %5 = alloca i8, align 1
  %6 = alloca i32, align 4
  %7 = alloca %struct.vec3, align 8
  %8 = alloca %struct.vec3, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca %struct.sphere*, align 8
  store %struct._IO_FILE* %0, %struct._IO_FILE** %2, align 8
  %13 = call noalias i8* @malloc(i64 80) #5
  %14 = bitcast i8* %13 to %struct.sphere*
  store %struct.sphere* %14, %struct.sphere** @obj_list, align 8
  %15 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %16 = getelementptr inbounds %struct.sphere, %struct.sphere* %15, i32 0, i32 3
  store %struct.sphere* null, %struct.sphere** %16, align 8
  br label %17

; <label>:17:                                     ; preds = %169, %126, %120, %113, %88, %78, %53, %48, %1
  %18 = getelementptr inbounds [256 x i8], [256 x i8]* %3, i32 0, i32 0
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** %2, align 8
  %20 = call i8* @fgets(i8* %18, i32 256, %struct._IO_FILE* %19)
  store i8* %20, i8** %4, align 8
  %21 = icmp ne i8* %20, null
  br i1 %21, label %22, label %170

; <label>:22:                                     ; preds = %17
  br label %23

; <label>:23:                                     ; preds = %35, %22
  %24 = load i8*, i8** %4, align 8
  %25 = load i8, i8* %24, align 1
  %26 = sext i8 %25 to i32
  %27 = icmp eq i32 %26, 32
  br i1 %27, label %33, label %28

; <label>:28:                                     ; preds = %23
  %29 = load i8*, i8** %4, align 8
  %30 = load i8, i8* %29, align 1
  %31 = sext i8 %30 to i32
  %32 = icmp eq i32 %31, 9
  br label %33

; <label>:33:                                     ; preds = %28, %23
  %34 = phi i1 [ true, %23 ], [ %32, %28 ]
  br i1 %34, label %35, label %38

; <label>:35:                                     ; preds = %33
  %36 = load i8*, i8** %4, align 8
  %37 = getelementptr inbounds i8, i8* %36, i32 1
  store i8* %37, i8** %4, align 8
  br label %23

; <label>:38:                                     ; preds = %33
  %39 = load i8*, i8** %4, align 8
  %40 = load i8, i8* %39, align 1
  %41 = sext i8 %40 to i32
  %42 = icmp eq i32 %41, 35
  br i1 %42, label %48, label %43

; <label>:43:                                     ; preds = %38
  %44 = load i8*, i8** %4, align 8
  %45 = load i8, i8* %44, align 1
  %46 = sext i8 %45 to i32
  %47 = icmp eq i32 %46, 10
  br i1 %47, label %48, label %49

; <label>:48:                                     ; preds = %43, %38
  br label %17

; <label>:49:                                     ; preds = %43
  %50 = getelementptr inbounds [256 x i8], [256 x i8]* %3, i32 0, i32 0
  %51 = call i8* @strtok(i8* %50, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %51, i8** %4, align 8
  %52 = icmp ne i8* %51, null
  br i1 %52, label %54, label %53

; <label>:53:                                     ; preds = %49
  br label %17

; <label>:54:                                     ; preds = %49
  %55 = load i8*, i8** %4, align 8
  %56 = load i8, i8* %55, align 1
  store i8 %56, i8* %5, align 1
  store i32 0, i32* %6, align 4
  br label %57

; <label>:57:                                     ; preds = %71, %54
  %58 = load i32, i32* %6, align 4
  %59 = icmp slt i32 %58, 3
  br i1 %59, label %60, label %74

; <label>:60:                                     ; preds = %57
  %61 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %61, i8** %4, align 8
  %62 = icmp ne i8* %61, null
  br i1 %62, label %64, label %63

; <label>:63:                                     ; preds = %60
  br label %74

; <label>:64:                                     ; preds = %60
  %65 = load i8*, i8** %4, align 8
  %66 = call double @atof(i8* %65) #6
  %67 = getelementptr inbounds %struct.vec3, %struct.vec3* %7, i32 0, i32 0
  %68 = load i32, i32* %6, align 4
  %69 = sext i32 %68 to i64
  %70 = getelementptr inbounds double, double* %67, i64 %69
  store double %66, double* %70, align 8
  br label %71

; <label>:71:                                     ; preds = %64
  %72 = load i32, i32* %6, align 4
  %73 = add nsw i32 %72, 1
  store i32 %73, i32* %6, align 4
  br label %57

; <label>:74:                                     ; preds = %63, %57
  %75 = load i8, i8* %5, align 1
  %76 = sext i8 %75 to i32
  %77 = icmp eq i32 %76, 108
  br i1 %77, label %78, label %85

; <label>:78:                                     ; preds = %74
  %79 = load i32, i32* @lnum, align 4
  %80 = add nsw i32 %79, 1
  store i32 %80, i32* @lnum, align 4
  %81 = sext i32 %79 to i64
  %82 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %81
  %83 = bitcast %struct.vec3* %82 to i8*
  %84 = bitcast %struct.vec3* %7 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %83, i8* align 8 %84, i64 24, i1 false)
  br label %17

; <label>:85:                                     ; preds = %74
  %86 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %86, i8** %4, align 8
  %87 = icmp ne i8* %86, null
  br i1 %87, label %89, label %88

; <label>:88:                                     ; preds = %85
  br label %17

; <label>:89:                                     ; preds = %85
  %90 = load i8*, i8** %4, align 8
  %91 = call double @atof(i8* %90) #6
  store double %91, double* %9, align 8
  store i32 0, i32* %6, align 4
  br label %92

; <label>:92:                                     ; preds = %106, %89
  %93 = load i32, i32* %6, align 4
  %94 = icmp slt i32 %93, 3
  br i1 %94, label %95, label %109

; <label>:95:                                     ; preds = %92
  %96 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %96, i8** %4, align 8
  %97 = icmp ne i8* %96, null
  br i1 %97, label %99, label %98

; <label>:98:                                     ; preds = %95
  br label %109

; <label>:99:                                     ; preds = %95
  %100 = load i8*, i8** %4, align 8
  %101 = call double @atof(i8* %100) #6
  %102 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 0
  %103 = load i32, i32* %6, align 4
  %104 = sext i32 %103 to i64
  %105 = getelementptr inbounds double, double* %102, i64 %104
  store double %101, double* %105, align 8
  br label %106

; <label>:106:                                    ; preds = %99
  %107 = load i32, i32* %6, align 4
  %108 = add nsw i32 %107, 1
  store i32 %108, i32* %6, align 4
  br label %92

; <label>:109:                                    ; preds = %98, %92
  %110 = load i8, i8* %5, align 1
  %111 = sext i8 %110 to i32
  %112 = icmp eq i32 %111, 99
  br i1 %112, label %113, label %117

; <label>:113:                                    ; preds = %109
  %114 = bitcast %struct.vec3* %7 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.camera* @cam to i8*), i8* align 8 %114, i64 24, i1 false)
  %115 = bitcast %struct.vec3* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.vec3* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1) to i8*), i8* align 8 %115, i64 24, i1 false)
  %116 = load double, double* %9, align 8
  store double %116, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 2), align 8
  br label %17

; <label>:117:                                    ; preds = %109
  %118 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %118, i8** %4, align 8
  %119 = icmp ne i8* %118, null
  br i1 %119, label %121, label %120

; <label>:120:                                    ; preds = %117
  br label %17

; <label>:121:                                    ; preds = %117
  %122 = load i8*, i8** %4, align 8
  %123 = call double @atof(i8* %122) #6
  store double %123, double* %10, align 8
  %124 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0)) #5
  store i8* %124, i8** %4, align 8
  %125 = icmp ne i8* %124, null
  br i1 %125, label %127, label %126

; <label>:126:                                    ; preds = %121
  br label %17

; <label>:127:                                    ; preds = %121
  %128 = load i8*, i8** %4, align 8
  %129 = call double @atof(i8* %128) #6
  store double %129, double* %11, align 8
  %130 = load i8, i8* %5, align 1
  %131 = sext i8 %130 to i32
  %132 = icmp eq i32 %131, 115
  br i1 %132, label %133, label %164

; <label>:133:                                    ; preds = %127
  %134 = call noalias i8* @malloc(i64 80) #5
  %135 = bitcast i8* %134 to %struct.sphere*
  store %struct.sphere* %135, %struct.sphere** %12, align 8
  %136 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %137 = getelementptr inbounds %struct.sphere, %struct.sphere* %136, i32 0, i32 3
  %138 = load %struct.sphere*, %struct.sphere** %137, align 8
  %139 = load %struct.sphere*, %struct.sphere** %12, align 8
  %140 = getelementptr inbounds %struct.sphere, %struct.sphere* %139, i32 0, i32 3
  store %struct.sphere* %138, %struct.sphere** %140, align 8
  %141 = load %struct.sphere*, %struct.sphere** %12, align 8
  %142 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %143 = getelementptr inbounds %struct.sphere, %struct.sphere* %142, i32 0, i32 3
  store %struct.sphere* %141, %struct.sphere** %143, align 8
  %144 = load %struct.sphere*, %struct.sphere** %12, align 8
  %145 = getelementptr inbounds %struct.sphere, %struct.sphere* %144, i32 0, i32 0
  %146 = bitcast %struct.vec3* %145 to i8*
  %147 = bitcast %struct.vec3* %7 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %146, i8* align 8 %147, i64 24, i1 false)
  %148 = load double, double* %9, align 8
  %149 = load %struct.sphere*, %struct.sphere** %12, align 8
  %150 = getelementptr inbounds %struct.sphere, %struct.sphere* %149, i32 0, i32 1
  store double %148, double* %150, align 8
  %151 = load %struct.sphere*, %struct.sphere** %12, align 8
  %152 = getelementptr inbounds %struct.sphere, %struct.sphere* %151, i32 0, i32 2
  %153 = getelementptr inbounds %struct.material, %struct.material* %152, i32 0, i32 0
  %154 = bitcast %struct.vec3* %153 to i8*
  %155 = bitcast %struct.vec3* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %154, i8* align 8 %155, i64 24, i1 false)
  %156 = load double, double* %10, align 8
  %157 = load %struct.sphere*, %struct.sphere** %12, align 8
  %158 = getelementptr inbounds %struct.sphere, %struct.sphere* %157, i32 0, i32 2
  %159 = getelementptr inbounds %struct.material, %struct.material* %158, i32 0, i32 1
  store double %156, double* %159, align 8
  %160 = load double, double* %11, align 8
  %161 = load %struct.sphere*, %struct.sphere** %12, align 8
  %162 = getelementptr inbounds %struct.sphere, %struct.sphere* %161, i32 0, i32 2
  %163 = getelementptr inbounds %struct.material, %struct.material* %162, i32 0, i32 2
  store double %160, double* %163, align 8
  br label %169

; <label>:164:                                    ; preds = %127
  %165 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %166 = load i8, i8* %5, align 1
  %167 = sext i8 %166 to i32
  %168 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %165, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.9, i32 0, i32 0), i32 %167)
  br label %169

; <label>:169:                                    ; preds = %164, %133
  br label %17

; <label>:170:                                    ; preds = %17
  ret void
}

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: noinline nounwind optnone uwtable
define i64 @get_msec() #0 {
  %1 = alloca i64, align 8
  %2 = call i32 @gettimeofday(%struct.timeval* @get_msec.timeval, %struct.timezone* null) #5
  %3 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i32 0, i32 0), align 8
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %6

; <label>:5:                                      ; preds = %0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.timeval* @get_msec.first_timeval to i8*), i8* align 8 bitcast (%struct.timeval* @get_msec.timeval to i8*), i64 16, i1 false)
  store i64 0, i64* %1, align 8
  br label %16

; <label>:6:                                      ; preds = %0
  %7 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i32 0, i32 0), align 8
  %8 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i32 0, i32 0), align 8
  %9 = sub nsw i64 %7, %8
  %10 = mul nsw i64 %9, 1000
  %11 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i32 0, i32 1), align 8
  %12 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i32 0, i32 1), align 8
  %13 = sub nsw i64 %11, %12
  %14 = sdiv i64 %13, 1000
  %15 = add nsw i64 %10, %14
  store i64 %15, i64* %1, align 8
  br label %16

; <label>:16:                                     ; preds = %6, %5
  %17 = load i64, i64* %1, align 8
  ret i64 %17
}

; Function Attrs: noinline nounwind optnone uwtable
define void @render(i32, i32, i32*, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca double, align 8
  %13 = alloca double, align 8
  %14 = alloca double, align 8
  %15 = alloca double, align 8
  %16 = alloca %struct.vec3, align 8
  %17 = alloca %struct.ray, align 8
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32* %2, i32** %7, align 8
  store i32 %3, i32* %8, align 4
  %18 = load i32, i32* %8, align 4
  %19 = sitofp i32 %18 to double
  %20 = fdiv double 1.000000e+00, %19
  store double %20, double* %12, align 8
  store i32 0, i32* %10, align 4
  br label %21

; <label>:21:                                     ; preds = %105, %4
  %22 = load i32, i32* %10, align 4
  %23 = load i32, i32* %6, align 4
  %24 = icmp slt i32 %22, %23
  br i1 %24, label %25, label %108

; <label>:25:                                     ; preds = %21
  store i32 0, i32* %9, align 4
  br label %26

; <label>:26:                                     ; preds = %101, %25
  %27 = load i32, i32* %9, align 4
  %28 = load i32, i32* %5, align 4
  %29 = icmp slt i32 %27, %28
  br i1 %29, label %30, label %104

; <label>:30:                                     ; preds = %26
  store double 0.000000e+00, double* %15, align 8
  store double 0.000000e+00, double* %14, align 8
  store double 0.000000e+00, double* %13, align 8
  store i32 0, i32* %11, align 4
  br label %31

; <label>:31:                                     ; preds = %51, %30
  %32 = load i32, i32* %11, align 4
  %33 = load i32, i32* %8, align 4
  %34 = icmp slt i32 %32, %33
  br i1 %34, label %35, label %54

; <label>:35:                                     ; preds = %31
  %36 = load i32, i32* %9, align 4
  %37 = load i32, i32* %10, align 4
  %38 = load i32, i32* %11, align 4
  call void @get_primary_ray(%struct.ray* sret %17, i32 %36, i32 %37, i32 %38)
  call void @trace(%struct.vec3* sret %16, %struct.ray* byval align 8 %17, i32 0)
  %39 = getelementptr inbounds %struct.vec3, %struct.vec3* %16, i32 0, i32 0
  %40 = load double, double* %39, align 8
  %41 = load double, double* %13, align 8
  %42 = fadd double %41, %40
  store double %42, double* %13, align 8
  %43 = getelementptr inbounds %struct.vec3, %struct.vec3* %16, i32 0, i32 1
  %44 = load double, double* %43, align 8
  %45 = load double, double* %14, align 8
  %46 = fadd double %45, %44
  store double %46, double* %14, align 8
  %47 = getelementptr inbounds %struct.vec3, %struct.vec3* %16, i32 0, i32 2
  %48 = load double, double* %47, align 8
  %49 = load double, double* %15, align 8
  %50 = fadd double %49, %48
  store double %50, double* %15, align 8
  br label %51

; <label>:51:                                     ; preds = %35
  %52 = load i32, i32* %11, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, i32* %11, align 4
  br label %31

; <label>:54:                                     ; preds = %31
  %55 = load double, double* %13, align 8
  %56 = load double, double* %12, align 8
  %57 = fmul double %55, %56
  store double %57, double* %13, align 8
  %58 = load double, double* %14, align 8
  %59 = load double, double* %12, align 8
  %60 = fmul double %58, %59
  store double %60, double* %14, align 8
  %61 = load double, double* %15, align 8
  %62 = load double, double* %12, align 8
  %63 = fmul double %61, %62
  store double %63, double* %15, align 8
  %64 = load double, double* %13, align 8
  %65 = fcmp olt double %64, 1.000000e+00
  br i1 %65, label %66, label %68

; <label>:66:                                     ; preds = %54
  %67 = load double, double* %13, align 8
  br label %69

; <label>:68:                                     ; preds = %54
  br label %69

; <label>:69:                                     ; preds = %68, %66
  %70 = phi double [ %67, %66 ], [ 1.000000e+00, %68 ]
  %71 = fmul double %70, 2.550000e+02
  %72 = fptoui double %71 to i32
  %73 = and i32 %72, 255
  %74 = shl i32 %73, 16
  %75 = load double, double* %14, align 8
  %76 = fcmp olt double %75, 1.000000e+00
  br i1 %76, label %77, label %79

; <label>:77:                                     ; preds = %69
  %78 = load double, double* %14, align 8
  br label %80

; <label>:79:                                     ; preds = %69
  br label %80

; <label>:80:                                     ; preds = %79, %77
  %81 = phi double [ %78, %77 ], [ 1.000000e+00, %79 ]
  %82 = fmul double %81, 2.550000e+02
  %83 = fptoui double %82 to i32
  %84 = and i32 %83, 255
  %85 = shl i32 %84, 8
  %86 = or i32 %74, %85
  %87 = load double, double* %15, align 8
  %88 = fcmp olt double %87, 1.000000e+00
  br i1 %88, label %89, label %91

; <label>:89:                                     ; preds = %80
  %90 = load double, double* %15, align 8
  br label %92

; <label>:91:                                     ; preds = %80
  br label %92

; <label>:92:                                     ; preds = %91, %89
  %93 = phi double [ %90, %89 ], [ 1.000000e+00, %91 ]
  %94 = fmul double %93, 2.550000e+02
  %95 = fptoui double %94 to i32
  %96 = and i32 %95, 255
  %97 = shl i32 %96, 0
  %98 = or i32 %86, %97
  %99 = load i32*, i32** %7, align 8
  %100 = getelementptr inbounds i32, i32* %99, i32 1
  store i32* %100, i32** %7, align 8
  store i32 %98, i32* %99, align 4
  br label %101

; <label>:101:                                    ; preds = %92
  %102 = load i32, i32* %9, align 4
  %103 = add nsw i32 %102, 1
  store i32 %103, i32* %9, align 4
  br label %26

; <label>:104:                                    ; preds = %26
  br label %105

; <label>:105:                                    ; preds = %104
  %106 = load i32, i32* %10, align 4
  %107 = add nsw i32 %106, 1
  store i32 %107, i32* %10, align 4
  br label %21

; <label>:108:                                    ; preds = %21
  ret void
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

declare i32 @fputc(i32, %struct._IO_FILE*) #1

declare i32 @fflush(%struct._IO_FILE*) #1

declare i32 @fclose(%struct._IO_FILE*) #1

; Function Attrs: noinline nounwind optnone uwtable
define void @trace(%struct.vec3* noalias sret, %struct.ray* byval align 8, i32) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.vec3, align 8
  %6 = alloca %struct.spoint, align 8
  %7 = alloca %struct.spoint, align 8
  %8 = alloca %struct.sphere*, align 8
  %9 = alloca %struct.sphere*, align 8
  %10 = alloca %struct.vec3, align 8
  store i32 %2, i32* %4, align 4
  store %struct.sphere* null, %struct.sphere** %8, align 8
  %11 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %12 = getelementptr inbounds %struct.sphere, %struct.sphere* %11, i32 0, i32 3
  %13 = load %struct.sphere*, %struct.sphere** %12, align 8
  store %struct.sphere* %13, %struct.sphere** %9, align 8
  %14 = load i32, i32* %4, align 4
  %15 = icmp sge i32 %14, 5
  br i1 %15, label %16, label %22

; <label>:16:                                     ; preds = %3
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 2
  store double 0.000000e+00, double* %17, align 8
  %18 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 1
  store double 0.000000e+00, double* %18, align 8
  %19 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 0
  store double 0.000000e+00, double* %19, align 8
  %20 = bitcast %struct.vec3* %0 to i8*
  %21 = bitcast %struct.vec3* %5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %20, i8* align 8 %21, i64 24, i1 false)
  br label %63

; <label>:22:                                     ; preds = %3
  br label %23

; <label>:23:                                     ; preds = %44, %22
  %24 = load %struct.sphere*, %struct.sphere** %9, align 8
  %25 = icmp ne %struct.sphere* %24, null
  br i1 %25, label %26, label %48

; <label>:26:                                     ; preds = %23
  %27 = load %struct.sphere*, %struct.sphere** %9, align 8
  %28 = call i32 @ray_sphere(%struct.sphere* %27, %struct.ray* byval align 8 %1, %struct.spoint* %6)
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %30, label %44

; <label>:30:                                     ; preds = %26
  %31 = load %struct.sphere*, %struct.sphere** %8, align 8
  %32 = icmp ne %struct.sphere* %31, null
  br i1 %32, label %33, label %39

; <label>:33:                                     ; preds = %30
  %34 = getelementptr inbounds %struct.spoint, %struct.spoint* %6, i32 0, i32 3
  %35 = load double, double* %34, align 8
  %36 = getelementptr inbounds %struct.spoint, %struct.spoint* %7, i32 0, i32 3
  %37 = load double, double* %36, align 8
  %38 = fcmp olt double %35, %37
  br i1 %38, label %39, label %43

; <label>:39:                                     ; preds = %33, %30
  %40 = load %struct.sphere*, %struct.sphere** %9, align 8
  store %struct.sphere* %40, %struct.sphere** %8, align 8
  %41 = bitcast %struct.spoint* %7 to i8*
  %42 = bitcast %struct.spoint* %6 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %41, i8* align 8 %42, i64 80, i1 false)
  br label %43

; <label>:43:                                     ; preds = %39, %33
  br label %44

; <label>:44:                                     ; preds = %43, %26
  %45 = load %struct.sphere*, %struct.sphere** %9, align 8
  %46 = getelementptr inbounds %struct.sphere, %struct.sphere* %45, i32 0, i32 3
  %47 = load %struct.sphere*, %struct.sphere** %46, align 8
  store %struct.sphere* %47, %struct.sphere** %9, align 8
  br label %23

; <label>:48:                                     ; preds = %23
  %49 = load %struct.sphere*, %struct.sphere** %8, align 8
  %50 = icmp ne %struct.sphere* %49, null
  br i1 %50, label %51, label %56

; <label>:51:                                     ; preds = %48
  %52 = load %struct.sphere*, %struct.sphere** %8, align 8
  %53 = load i32, i32* %4, align 4
  call void @shade(%struct.vec3* sret %10, %struct.sphere* %52, %struct.spoint* %7, i32 %53)
  %54 = bitcast %struct.vec3* %5 to i8*
  %55 = bitcast %struct.vec3* %10 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %54, i8* align 8 %55, i64 24, i1 false)
  br label %60

; <label>:56:                                     ; preds = %48
  %57 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 2
  store double 0.000000e+00, double* %57, align 8
  %58 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 1
  store double 0.000000e+00, double* %58, align 8
  %59 = getelementptr inbounds %struct.vec3, %struct.vec3* %5, i32 0, i32 0
  store double 0.000000e+00, double* %59, align 8
  br label %60

; <label>:60:                                     ; preds = %56, %51
  %61 = bitcast %struct.vec3* %0 to i8*
  %62 = bitcast %struct.vec3* %5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %61, i8* align 8 %62, i64 24, i1 false)
  br label %63

; <label>:63:                                     ; preds = %60, %16
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define void @get_primary_ray(%struct.ray* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca %struct.ray, align 8
  %9 = alloca [3 x [3 x float]], align 16
  %10 = alloca %struct.vec3, align 8
  %11 = alloca %struct.vec3, align 8
  %12 = alloca %struct.vec3, align 8
  %13 = alloca %struct.vec3, align 8
  %14 = alloca %struct.vec3, align 8
  %15 = alloca %struct.vec3, align 8
  %16 = alloca double, align 8
  %17 = alloca %struct.vec3, align 8
  %18 = alloca %struct.vec3, align 8
  %19 = alloca %struct.vec3, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  %20 = bitcast %struct.vec3* %11 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %20, i8* align 8 bitcast (%struct.vec3* @get_primary_ray.j to i8*), i64 24, i1 false)
  %21 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 0), align 8
  %22 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 0), align 8
  %23 = fsub double %21, %22
  %24 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  store double %23, double* %24, align 8
  %25 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 1), align 8
  %26 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 1), align 8
  %27 = fsub double %25, %26
  %28 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  store double %27, double* %28, align 8
  %29 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 2), align 8
  %30 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 2), align 8
  %31 = fsub double %29, %30
  %32 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  store double %31, double* %32, align 8
  br label %33

; <label>:33:                                     ; preds = %4
  %34 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %35 = load double, double* %34, align 8
  %36 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %37 = load double, double* %36, align 8
  %38 = fmul double %35, %37
  %39 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %40 = load double, double* %39, align 8
  %41 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %42 = load double, double* %41, align 8
  %43 = fmul double %40, %42
  %44 = fadd double %38, %43
  %45 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %46 = load double, double* %45, align 8
  %47 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %48 = load double, double* %47, align 8
  %49 = fmul double %46, %48
  %50 = fadd double %44, %49
  %51 = call double @sqrt(double %50) #5
  store double %51, double* %16, align 8
  %52 = load double, double* %16, align 8
  %53 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %54 = load double, double* %53, align 8
  %55 = fdiv double %54, %52
  store double %55, double* %53, align 8
  %56 = load double, double* %16, align 8
  %57 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %58 = load double, double* %57, align 8
  %59 = fdiv double %58, %56
  store double %59, double* %57, align 8
  %60 = load double, double* %16, align 8
  %61 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %62 = load double, double* %61, align 8
  %63 = fdiv double %62, %60
  store double %63, double* %61, align 8
  br label %64

; <label>:64:                                     ; preds = %33
  call void @cross_product(%struct.vec3* sret %17, %struct.vec3* byval align 8 %11, %struct.vec3* byval align 8 %12)
  %65 = bitcast %struct.vec3* %10 to i8*
  %66 = bitcast %struct.vec3* %17 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %65, i8* align 8 %66, i64 24, i1 false)
  call void @cross_product(%struct.vec3* sret %18, %struct.vec3* byval align 8 %12, %struct.vec3* byval align 8 %10)
  %67 = bitcast %struct.vec3* %11 to i8*
  %68 = bitcast %struct.vec3* %18 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %67, i8* align 8 %68, i64 24, i1 false)
  %69 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 0
  %70 = load double, double* %69, align 8
  %71 = fptrunc double %70 to float
  %72 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %73 = getelementptr inbounds [3 x float], [3 x float]* %72, i64 0, i64 0
  store float %71, float* %73, align 16
  %74 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %75 = load double, double* %74, align 8
  %76 = fptrunc double %75 to float
  %77 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %78 = getelementptr inbounds [3 x float], [3 x float]* %77, i64 0, i64 1
  store float %76, float* %78, align 4
  %79 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %80 = load double, double* %79, align 8
  %81 = fptrunc double %80 to float
  %82 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %83 = getelementptr inbounds [3 x float], [3 x float]* %82, i64 0, i64 2
  store float %81, float* %83, align 8
  %84 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 1
  %85 = load double, double* %84, align 8
  %86 = fptrunc double %85 to float
  %87 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %88 = getelementptr inbounds [3 x float], [3 x float]* %87, i64 0, i64 0
  store float %86, float* %88, align 4
  %89 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %90 = load double, double* %89, align 8
  %91 = fptrunc double %90 to float
  %92 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %93 = getelementptr inbounds [3 x float], [3 x float]* %92, i64 0, i64 1
  store float %91, float* %93, align 4
  %94 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %95 = load double, double* %94, align 8
  %96 = fptrunc double %95 to float
  %97 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %98 = getelementptr inbounds [3 x float], [3 x float]* %97, i64 0, i64 2
  store float %96, float* %98, align 4
  %99 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 2
  %100 = load double, double* %99, align 8
  %101 = fptrunc double %100 to float
  %102 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %103 = getelementptr inbounds [3 x float], [3 x float]* %102, i64 0, i64 0
  store float %101, float* %103, align 8
  %104 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %105 = load double, double* %104, align 8
  %106 = fptrunc double %105 to float
  %107 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %108 = getelementptr inbounds [3 x float], [3 x float]* %107, i64 0, i64 1
  store float %106, float* %108, align 4
  %109 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %110 = load double, double* %109, align 8
  %111 = fptrunc double %110 to float
  %112 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %113 = getelementptr inbounds [3 x float], [3 x float]* %112, i64 0, i64 2
  store float %111, float* %113, align 8
  %114 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %115 = getelementptr inbounds %struct.vec3, %struct.vec3* %114, i32 0, i32 2
  store double 0.000000e+00, double* %115, align 8
  %116 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %117 = getelementptr inbounds %struct.vec3, %struct.vec3* %116, i32 0, i32 1
  store double 0.000000e+00, double* %117, align 8
  %118 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %119 = getelementptr inbounds %struct.vec3, %struct.vec3* %118, i32 0, i32 0
  store double 0.000000e+00, double* %119, align 8
  %120 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %121 = load i32, i32* %5, align 4
  %122 = load i32, i32* %6, align 4
  %123 = load i32, i32* %7, align 4
  call void @get_sample_pos(%struct.vec3* sret %19, i32 %121, i32 %122, i32 %123)
  %124 = bitcast %struct.vec3* %120 to i8*
  %125 = bitcast %struct.vec3* %19 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %124, i8* align 8 %125, i64 24, i1 false)
  %126 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %127 = getelementptr inbounds %struct.vec3, %struct.vec3* %126, i32 0, i32 2
  store double 0x40045F306F4445A0, double* %127, align 8
  %128 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %129 = getelementptr inbounds %struct.vec3, %struct.vec3* %128, i32 0, i32 0
  %130 = load double, double* %129, align 8
  %131 = fmul double %130, 1.000000e+03
  store double %131, double* %129, align 8
  %132 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %133 = getelementptr inbounds %struct.vec3, %struct.vec3* %132, i32 0, i32 1
  %134 = load double, double* %133, align 8
  %135 = fmul double %134, 1.000000e+03
  store double %135, double* %133, align 8
  %136 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %137 = getelementptr inbounds %struct.vec3, %struct.vec3* %136, i32 0, i32 2
  %138 = load double, double* %137, align 8
  %139 = fmul double %138, 1.000000e+03
  store double %139, double* %137, align 8
  %140 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %141 = getelementptr inbounds %struct.vec3, %struct.vec3* %140, i32 0, i32 0
  %142 = load double, double* %141, align 8
  %143 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %144 = getelementptr inbounds %struct.vec3, %struct.vec3* %143, i32 0, i32 0
  %145 = load double, double* %144, align 8
  %146 = fadd double %142, %145
  %147 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  store double %146, double* %147, align 8
  %148 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %149 = getelementptr inbounds %struct.vec3, %struct.vec3* %148, i32 0, i32 1
  %150 = load double, double* %149, align 8
  %151 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %152 = getelementptr inbounds %struct.vec3, %struct.vec3* %151, i32 0, i32 1
  %153 = load double, double* %152, align 8
  %154 = fadd double %150, %153
  %155 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  store double %154, double* %155, align 8
  %156 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %157 = getelementptr inbounds %struct.vec3, %struct.vec3* %156, i32 0, i32 2
  %158 = load double, double* %157, align 8
  %159 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %160 = getelementptr inbounds %struct.vec3, %struct.vec3* %159, i32 0, i32 2
  %161 = load double, double* %160, align 8
  %162 = fadd double %158, %161
  %163 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  store double %162, double* %163, align 8
  %164 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  %165 = load double, double* %164, align 8
  %166 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %167 = getelementptr inbounds [3 x float], [3 x float]* %166, i64 0, i64 0
  %168 = load float, float* %167, align 16
  %169 = fpext float %168 to double
  %170 = fmul double %165, %169
  %171 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  %172 = load double, double* %171, align 8
  %173 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %174 = getelementptr inbounds [3 x float], [3 x float]* %173, i64 0, i64 1
  %175 = load float, float* %174, align 4
  %176 = fpext float %175 to double
  %177 = fmul double %172, %176
  %178 = fadd double %170, %177
  %179 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  %180 = load double, double* %179, align 8
  %181 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %182 = getelementptr inbounds [3 x float], [3 x float]* %181, i64 0, i64 2
  %183 = load float, float* %182, align 8
  %184 = fpext float %183 to double
  %185 = fmul double %180, %184
  %186 = fadd double %178, %185
  %187 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 0
  store double %186, double* %187, align 8
  %188 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  %189 = load double, double* %188, align 8
  %190 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %191 = getelementptr inbounds [3 x float], [3 x float]* %190, i64 0, i64 0
  %192 = load float, float* %191, align 4
  %193 = fpext float %192 to double
  %194 = fmul double %189, %193
  %195 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  %196 = load double, double* %195, align 8
  %197 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %198 = getelementptr inbounds [3 x float], [3 x float]* %197, i64 0, i64 1
  %199 = load float, float* %198, align 4
  %200 = fpext float %199 to double
  %201 = fmul double %196, %200
  %202 = fadd double %194, %201
  %203 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  %204 = load double, double* %203, align 8
  %205 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %206 = getelementptr inbounds [3 x float], [3 x float]* %205, i64 0, i64 2
  %207 = load float, float* %206, align 4
  %208 = fpext float %207 to double
  %209 = fmul double %204, %208
  %210 = fadd double %202, %209
  %211 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 1
  store double %210, double* %211, align 8
  %212 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  %213 = load double, double* %212, align 8
  %214 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %215 = getelementptr inbounds [3 x float], [3 x float]* %214, i64 0, i64 0
  %216 = load float, float* %215, align 8
  %217 = fpext float %216 to double
  %218 = fmul double %213, %217
  %219 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  %220 = load double, double* %219, align 8
  %221 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %222 = getelementptr inbounds [3 x float], [3 x float]* %221, i64 0, i64 1
  %223 = load float, float* %222, align 4
  %224 = fpext float %223 to double
  %225 = fmul double %220, %224
  %226 = fadd double %218, %225
  %227 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  %228 = load double, double* %227, align 8
  %229 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %230 = getelementptr inbounds [3 x float], [3 x float]* %229, i64 0, i64 2
  %231 = load float, float* %230, align 8
  %232 = fpext float %231 to double
  %233 = fmul double %228, %232
  %234 = fadd double %226, %233
  %235 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 2
  store double %234, double* %235, align 8
  %236 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %237 = getelementptr inbounds %struct.vec3, %struct.vec3* %236, i32 0, i32 0
  %238 = load double, double* %237, align 8
  %239 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %240 = getelementptr inbounds [3 x float], [3 x float]* %239, i64 0, i64 0
  %241 = load float, float* %240, align 16
  %242 = fpext float %241 to double
  %243 = fmul double %238, %242
  %244 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %245 = getelementptr inbounds %struct.vec3, %struct.vec3* %244, i32 0, i32 1
  %246 = load double, double* %245, align 8
  %247 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %248 = getelementptr inbounds [3 x float], [3 x float]* %247, i64 0, i64 1
  %249 = load float, float* %248, align 4
  %250 = fpext float %249 to double
  %251 = fmul double %246, %250
  %252 = fadd double %243, %251
  %253 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %254 = getelementptr inbounds %struct.vec3, %struct.vec3* %253, i32 0, i32 2
  %255 = load double, double* %254, align 8
  %256 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 0
  %257 = getelementptr inbounds [3 x float], [3 x float]* %256, i64 0, i64 2
  %258 = load float, float* %257, align 8
  %259 = fpext float %258 to double
  %260 = fmul double %255, %259
  %261 = fadd double %252, %260
  %262 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 0), align 8
  %263 = fadd double %261, %262
  %264 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 0
  store double %263, double* %264, align 8
  %265 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %266 = getelementptr inbounds %struct.vec3, %struct.vec3* %265, i32 0, i32 0
  %267 = load double, double* %266, align 8
  %268 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %269 = getelementptr inbounds [3 x float], [3 x float]* %268, i64 0, i64 0
  %270 = load float, float* %269, align 4
  %271 = fpext float %270 to double
  %272 = fmul double %267, %271
  %273 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %274 = getelementptr inbounds %struct.vec3, %struct.vec3* %273, i32 0, i32 1
  %275 = load double, double* %274, align 8
  %276 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %277 = getelementptr inbounds [3 x float], [3 x float]* %276, i64 0, i64 1
  %278 = load float, float* %277, align 4
  %279 = fpext float %278 to double
  %280 = fmul double %275, %279
  %281 = fadd double %272, %280
  %282 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %283 = getelementptr inbounds %struct.vec3, %struct.vec3* %282, i32 0, i32 2
  %284 = load double, double* %283, align 8
  %285 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 1
  %286 = getelementptr inbounds [3 x float], [3 x float]* %285, i64 0, i64 2
  %287 = load float, float* %286, align 4
  %288 = fpext float %287 to double
  %289 = fmul double %284, %288
  %290 = fadd double %281, %289
  %291 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 1), align 8
  %292 = fadd double %290, %291
  %293 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 1
  store double %292, double* %293, align 8
  %294 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %295 = getelementptr inbounds %struct.vec3, %struct.vec3* %294, i32 0, i32 0
  %296 = load double, double* %295, align 8
  %297 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %298 = getelementptr inbounds [3 x float], [3 x float]* %297, i64 0, i64 0
  %299 = load float, float* %298, align 8
  %300 = fpext float %299 to double
  %301 = fmul double %296, %300
  %302 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %303 = getelementptr inbounds %struct.vec3, %struct.vec3* %302, i32 0, i32 1
  %304 = load double, double* %303, align 8
  %305 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %306 = getelementptr inbounds [3 x float], [3 x float]* %305, i64 0, i64 1
  %307 = load float, float* %306, align 4
  %308 = fpext float %307 to double
  %309 = fmul double %304, %308
  %310 = fadd double %301, %309
  %311 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %312 = getelementptr inbounds %struct.vec3, %struct.vec3* %311, i32 0, i32 2
  %313 = load double, double* %312, align 8
  %314 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %9, i64 0, i64 2
  %315 = getelementptr inbounds [3 x float], [3 x float]* %314, i64 0, i64 2
  %316 = load float, float* %315, align 8
  %317 = fpext float %316 to double
  %318 = fmul double %313, %317
  %319 = fadd double %310, %318
  %320 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 2), align 8
  %321 = fadd double %319, %320
  %322 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 2
  store double %321, double* %322, align 8
  %323 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 0
  %324 = bitcast %struct.vec3* %323 to i8*
  %325 = bitcast %struct.vec3* %14 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %324, i8* align 8 %325, i64 24, i1 false)
  %326 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 0
  %327 = load double, double* %326, align 8
  %328 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 0
  %329 = load double, double* %328, align 8
  %330 = fadd double %327, %329
  %331 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %332 = getelementptr inbounds %struct.vec3, %struct.vec3* %331, i32 0, i32 0
  store double %330, double* %332, align 8
  %333 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 1
  %334 = load double, double* %333, align 8
  %335 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 1
  %336 = load double, double* %335, align 8
  %337 = fadd double %334, %336
  %338 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %339 = getelementptr inbounds %struct.vec3, %struct.vec3* %338, i32 0, i32 1
  store double %337, double* %339, align 8
  %340 = getelementptr inbounds %struct.vec3, %struct.vec3* %15, i32 0, i32 2
  %341 = load double, double* %340, align 8
  %342 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 2
  %343 = load double, double* %342, align 8
  %344 = fadd double %341, %343
  %345 = getelementptr inbounds %struct.ray, %struct.ray* %8, i32 0, i32 1
  %346 = getelementptr inbounds %struct.vec3, %struct.vec3* %345, i32 0, i32 2
  store double %344, double* %346, align 8
  %347 = bitcast %struct.ray* %0 to i8*
  %348 = bitcast %struct.ray* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %347, i8* align 8 %348, i64 48, i1 false)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @ray_sphere(%struct.sphere*, %struct.ray* byval align 8, %struct.spoint*) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.sphere*, align 8
  %6 = alloca %struct.spoint*, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca double, align 8
  %14 = alloca %struct.vec3, align 8
  %15 = alloca double, align 8
  store %struct.sphere* %0, %struct.sphere** %5, align 8
  store %struct.spoint* %2, %struct.spoint** %6, align 8
  %16 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %16, i32 0, i32 0
  %18 = load double, double* %17, align 8
  %19 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %20 = getelementptr inbounds %struct.vec3, %struct.vec3* %19, i32 0, i32 0
  %21 = load double, double* %20, align 8
  %22 = fmul double %18, %21
  %23 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %24 = getelementptr inbounds %struct.vec3, %struct.vec3* %23, i32 0, i32 1
  %25 = load double, double* %24, align 8
  %26 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %27 = getelementptr inbounds %struct.vec3, %struct.vec3* %26, i32 0, i32 1
  %28 = load double, double* %27, align 8
  %29 = fmul double %25, %28
  %30 = fadd double %22, %29
  %31 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %32 = getelementptr inbounds %struct.vec3, %struct.vec3* %31, i32 0, i32 2
  %33 = load double, double* %32, align 8
  %34 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %34, i32 0, i32 2
  %36 = load double, double* %35, align 8
  %37 = fmul double %33, %36
  %38 = fadd double %30, %37
  store double %38, double* %7, align 8
  %39 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %40 = getelementptr inbounds %struct.vec3, %struct.vec3* %39, i32 0, i32 0
  %41 = load double, double* %40, align 8
  %42 = fmul double 2.000000e+00, %41
  %43 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %44 = getelementptr inbounds %struct.vec3, %struct.vec3* %43, i32 0, i32 0
  %45 = load double, double* %44, align 8
  %46 = load %struct.sphere*, %struct.sphere** %5, align 8
  %47 = getelementptr inbounds %struct.sphere, %struct.sphere* %46, i32 0, i32 0
  %48 = getelementptr inbounds %struct.vec3, %struct.vec3* %47, i32 0, i32 0
  %49 = load double, double* %48, align 8
  %50 = fsub double %45, %49
  %51 = fmul double %42, %50
  %52 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %53 = getelementptr inbounds %struct.vec3, %struct.vec3* %52, i32 0, i32 1
  %54 = load double, double* %53, align 8
  %55 = fmul double 2.000000e+00, %54
  %56 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %57 = getelementptr inbounds %struct.vec3, %struct.vec3* %56, i32 0, i32 1
  %58 = load double, double* %57, align 8
  %59 = load %struct.sphere*, %struct.sphere** %5, align 8
  %60 = getelementptr inbounds %struct.sphere, %struct.sphere* %59, i32 0, i32 0
  %61 = getelementptr inbounds %struct.vec3, %struct.vec3* %60, i32 0, i32 1
  %62 = load double, double* %61, align 8
  %63 = fsub double %58, %62
  %64 = fmul double %55, %63
  %65 = fadd double %51, %64
  %66 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %67 = getelementptr inbounds %struct.vec3, %struct.vec3* %66, i32 0, i32 2
  %68 = load double, double* %67, align 8
  %69 = fmul double 2.000000e+00, %68
  %70 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %71 = getelementptr inbounds %struct.vec3, %struct.vec3* %70, i32 0, i32 2
  %72 = load double, double* %71, align 8
  %73 = load %struct.sphere*, %struct.sphere** %5, align 8
  %74 = getelementptr inbounds %struct.sphere, %struct.sphere* %73, i32 0, i32 0
  %75 = getelementptr inbounds %struct.vec3, %struct.vec3* %74, i32 0, i32 2
  %76 = load double, double* %75, align 8
  %77 = fsub double %72, %76
  %78 = fmul double %69, %77
  %79 = fadd double %65, %78
  store double %79, double* %8, align 8
  %80 = load %struct.sphere*, %struct.sphere** %5, align 8
  %81 = getelementptr inbounds %struct.sphere, %struct.sphere* %80, i32 0, i32 0
  %82 = getelementptr inbounds %struct.vec3, %struct.vec3* %81, i32 0, i32 0
  %83 = load double, double* %82, align 8
  %84 = load %struct.sphere*, %struct.sphere** %5, align 8
  %85 = getelementptr inbounds %struct.sphere, %struct.sphere* %84, i32 0, i32 0
  %86 = getelementptr inbounds %struct.vec3, %struct.vec3* %85, i32 0, i32 0
  %87 = load double, double* %86, align 8
  %88 = fmul double %83, %87
  %89 = load %struct.sphere*, %struct.sphere** %5, align 8
  %90 = getelementptr inbounds %struct.sphere, %struct.sphere* %89, i32 0, i32 0
  %91 = getelementptr inbounds %struct.vec3, %struct.vec3* %90, i32 0, i32 1
  %92 = load double, double* %91, align 8
  %93 = load %struct.sphere*, %struct.sphere** %5, align 8
  %94 = getelementptr inbounds %struct.sphere, %struct.sphere* %93, i32 0, i32 0
  %95 = getelementptr inbounds %struct.vec3, %struct.vec3* %94, i32 0, i32 1
  %96 = load double, double* %95, align 8
  %97 = fmul double %92, %96
  %98 = fadd double %88, %97
  %99 = load %struct.sphere*, %struct.sphere** %5, align 8
  %100 = getelementptr inbounds %struct.sphere, %struct.sphere* %99, i32 0, i32 0
  %101 = getelementptr inbounds %struct.vec3, %struct.vec3* %100, i32 0, i32 2
  %102 = load double, double* %101, align 8
  %103 = load %struct.sphere*, %struct.sphere** %5, align 8
  %104 = getelementptr inbounds %struct.sphere, %struct.sphere* %103, i32 0, i32 0
  %105 = getelementptr inbounds %struct.vec3, %struct.vec3* %104, i32 0, i32 2
  %106 = load double, double* %105, align 8
  %107 = fmul double %102, %106
  %108 = fadd double %98, %107
  %109 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %110 = getelementptr inbounds %struct.vec3, %struct.vec3* %109, i32 0, i32 0
  %111 = load double, double* %110, align 8
  %112 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %113 = getelementptr inbounds %struct.vec3, %struct.vec3* %112, i32 0, i32 0
  %114 = load double, double* %113, align 8
  %115 = fmul double %111, %114
  %116 = fadd double %108, %115
  %117 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %118 = getelementptr inbounds %struct.vec3, %struct.vec3* %117, i32 0, i32 1
  %119 = load double, double* %118, align 8
  %120 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %121 = getelementptr inbounds %struct.vec3, %struct.vec3* %120, i32 0, i32 1
  %122 = load double, double* %121, align 8
  %123 = fmul double %119, %122
  %124 = fadd double %116, %123
  %125 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %126 = getelementptr inbounds %struct.vec3, %struct.vec3* %125, i32 0, i32 2
  %127 = load double, double* %126, align 8
  %128 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %129 = getelementptr inbounds %struct.vec3, %struct.vec3* %128, i32 0, i32 2
  %130 = load double, double* %129, align 8
  %131 = fmul double %127, %130
  %132 = fadd double %124, %131
  %133 = load %struct.sphere*, %struct.sphere** %5, align 8
  %134 = getelementptr inbounds %struct.sphere, %struct.sphere* %133, i32 0, i32 0
  %135 = getelementptr inbounds %struct.vec3, %struct.vec3* %134, i32 0, i32 0
  %136 = load double, double* %135, align 8
  %137 = fsub double -0.000000e+00, %136
  %138 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %139 = getelementptr inbounds %struct.vec3, %struct.vec3* %138, i32 0, i32 0
  %140 = load double, double* %139, align 8
  %141 = fmul double %137, %140
  %142 = load %struct.sphere*, %struct.sphere** %5, align 8
  %143 = getelementptr inbounds %struct.sphere, %struct.sphere* %142, i32 0, i32 0
  %144 = getelementptr inbounds %struct.vec3, %struct.vec3* %143, i32 0, i32 1
  %145 = load double, double* %144, align 8
  %146 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %147 = getelementptr inbounds %struct.vec3, %struct.vec3* %146, i32 0, i32 1
  %148 = load double, double* %147, align 8
  %149 = fmul double %145, %148
  %150 = fsub double %141, %149
  %151 = load %struct.sphere*, %struct.sphere** %5, align 8
  %152 = getelementptr inbounds %struct.sphere, %struct.sphere* %151, i32 0, i32 0
  %153 = getelementptr inbounds %struct.vec3, %struct.vec3* %152, i32 0, i32 2
  %154 = load double, double* %153, align 8
  %155 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %156 = getelementptr inbounds %struct.vec3, %struct.vec3* %155, i32 0, i32 2
  %157 = load double, double* %156, align 8
  %158 = fmul double %154, %157
  %159 = fsub double %150, %158
  %160 = fmul double 2.000000e+00, %159
  %161 = fadd double %132, %160
  %162 = load %struct.sphere*, %struct.sphere** %5, align 8
  %163 = getelementptr inbounds %struct.sphere, %struct.sphere* %162, i32 0, i32 1
  %164 = load double, double* %163, align 8
  %165 = load %struct.sphere*, %struct.sphere** %5, align 8
  %166 = getelementptr inbounds %struct.sphere, %struct.sphere* %165, i32 0, i32 1
  %167 = load double, double* %166, align 8
  %168 = fmul double %164, %167
  %169 = fsub double %161, %168
  store double %169, double* %9, align 8
  %170 = load double, double* %8, align 8
  %171 = load double, double* %8, align 8
  %172 = fmul double %170, %171
  %173 = load double, double* %7, align 8
  %174 = fmul double 4.000000e+00, %173
  %175 = load double, double* %9, align 8
  %176 = fmul double %174, %175
  %177 = fsub double %172, %176
  store double %177, double* %10, align 8
  %178 = fcmp olt double %177, 0.000000e+00
  br i1 %178, label %179, label %180

; <label>:179:                                    ; preds = %3
  store i32 0, i32* %4, align 4
  br label %382

; <label>:180:                                    ; preds = %3
  %181 = load double, double* %10, align 8
  %182 = call double @sqrt(double %181) #5
  store double %182, double* %11, align 8
  %183 = load double, double* %8, align 8
  %184 = fsub double -0.000000e+00, %183
  %185 = load double, double* %11, align 8
  %186 = fadd double %184, %185
  %187 = load double, double* %7, align 8
  %188 = fmul double 2.000000e+00, %187
  %189 = fdiv double %186, %188
  store double %189, double* %12, align 8
  %190 = load double, double* %8, align 8
  %191 = fsub double -0.000000e+00, %190
  %192 = load double, double* %11, align 8
  %193 = fsub double %191, %192
  %194 = load double, double* %7, align 8
  %195 = fmul double 2.000000e+00, %194
  %196 = fdiv double %193, %195
  store double %196, double* %13, align 8
  %197 = load double, double* %12, align 8
  %198 = fcmp olt double %197, 0x3EB0C6F7A0B5ED8D
  br i1 %198, label %199, label %202

; <label>:199:                                    ; preds = %180
  %200 = load double, double* %13, align 8
  %201 = fcmp olt double %200, 0x3EB0C6F7A0B5ED8D
  br i1 %201, label %208, label %202

; <label>:202:                                    ; preds = %199, %180
  %203 = load double, double* %12, align 8
  %204 = fcmp ogt double %203, 1.000000e+00
  br i1 %204, label %205, label %209

; <label>:205:                                    ; preds = %202
  %206 = load double, double* %13, align 8
  %207 = fcmp ogt double %206, 1.000000e+00
  br i1 %207, label %208, label %209

; <label>:208:                                    ; preds = %205, %199
  store i32 0, i32* %4, align 4
  br label %382

; <label>:209:                                    ; preds = %205, %202
  %210 = load %struct.spoint*, %struct.spoint** %6, align 8
  %211 = icmp ne %struct.spoint* %210, null
  br i1 %211, label %212, label %381

; <label>:212:                                    ; preds = %209
  %213 = load double, double* %12, align 8
  %214 = fcmp olt double %213, 0x3EB0C6F7A0B5ED8D
  br i1 %214, label %215, label %217

; <label>:215:                                    ; preds = %212
  %216 = load double, double* %13, align 8
  store double %216, double* %12, align 8
  br label %217

; <label>:217:                                    ; preds = %215, %212
  %218 = load double, double* %13, align 8
  %219 = fcmp olt double %218, 0x3EB0C6F7A0B5ED8D
  br i1 %219, label %220, label %222

; <label>:220:                                    ; preds = %217
  %221 = load double, double* %12, align 8
  store double %221, double* %13, align 8
  br label %222

; <label>:222:                                    ; preds = %220, %217
  %223 = load double, double* %12, align 8
  %224 = load double, double* %13, align 8
  %225 = fcmp olt double %223, %224
  br i1 %225, label %226, label %228

; <label>:226:                                    ; preds = %222
  %227 = load double, double* %12, align 8
  br label %230

; <label>:228:                                    ; preds = %222
  %229 = load double, double* %13, align 8
  br label %230

; <label>:230:                                    ; preds = %228, %226
  %231 = phi double [ %227, %226 ], [ %229, %228 ]
  %232 = load %struct.spoint*, %struct.spoint** %6, align 8
  %233 = getelementptr inbounds %struct.spoint, %struct.spoint* %232, i32 0, i32 3
  store double %231, double* %233, align 8
  %234 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %235 = getelementptr inbounds %struct.vec3, %struct.vec3* %234, i32 0, i32 0
  %236 = load double, double* %235, align 8
  %237 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %238 = getelementptr inbounds %struct.vec3, %struct.vec3* %237, i32 0, i32 0
  %239 = load double, double* %238, align 8
  %240 = load %struct.spoint*, %struct.spoint** %6, align 8
  %241 = getelementptr inbounds %struct.spoint, %struct.spoint* %240, i32 0, i32 3
  %242 = load double, double* %241, align 8
  %243 = fmul double %239, %242
  %244 = fadd double %236, %243
  %245 = load %struct.spoint*, %struct.spoint** %6, align 8
  %246 = getelementptr inbounds %struct.spoint, %struct.spoint* %245, i32 0, i32 0
  %247 = getelementptr inbounds %struct.vec3, %struct.vec3* %246, i32 0, i32 0
  store double %244, double* %247, align 8
  %248 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %249 = getelementptr inbounds %struct.vec3, %struct.vec3* %248, i32 0, i32 1
  %250 = load double, double* %249, align 8
  %251 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %252 = getelementptr inbounds %struct.vec3, %struct.vec3* %251, i32 0, i32 1
  %253 = load double, double* %252, align 8
  %254 = load %struct.spoint*, %struct.spoint** %6, align 8
  %255 = getelementptr inbounds %struct.spoint, %struct.spoint* %254, i32 0, i32 3
  %256 = load double, double* %255, align 8
  %257 = fmul double %253, %256
  %258 = fadd double %250, %257
  %259 = load %struct.spoint*, %struct.spoint** %6, align 8
  %260 = getelementptr inbounds %struct.spoint, %struct.spoint* %259, i32 0, i32 0
  %261 = getelementptr inbounds %struct.vec3, %struct.vec3* %260, i32 0, i32 1
  store double %258, double* %261, align 8
  %262 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 0
  %263 = getelementptr inbounds %struct.vec3, %struct.vec3* %262, i32 0, i32 2
  %264 = load double, double* %263, align 8
  %265 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %266 = getelementptr inbounds %struct.vec3, %struct.vec3* %265, i32 0, i32 2
  %267 = load double, double* %266, align 8
  %268 = load %struct.spoint*, %struct.spoint** %6, align 8
  %269 = getelementptr inbounds %struct.spoint, %struct.spoint* %268, i32 0, i32 3
  %270 = load double, double* %269, align 8
  %271 = fmul double %267, %270
  %272 = fadd double %264, %271
  %273 = load %struct.spoint*, %struct.spoint** %6, align 8
  %274 = getelementptr inbounds %struct.spoint, %struct.spoint* %273, i32 0, i32 0
  %275 = getelementptr inbounds %struct.vec3, %struct.vec3* %274, i32 0, i32 2
  store double %272, double* %275, align 8
  %276 = load %struct.spoint*, %struct.spoint** %6, align 8
  %277 = getelementptr inbounds %struct.spoint, %struct.spoint* %276, i32 0, i32 0
  %278 = getelementptr inbounds %struct.vec3, %struct.vec3* %277, i32 0, i32 0
  %279 = load double, double* %278, align 8
  %280 = load %struct.sphere*, %struct.sphere** %5, align 8
  %281 = getelementptr inbounds %struct.sphere, %struct.sphere* %280, i32 0, i32 0
  %282 = getelementptr inbounds %struct.vec3, %struct.vec3* %281, i32 0, i32 0
  %283 = load double, double* %282, align 8
  %284 = fsub double %279, %283
  %285 = load %struct.sphere*, %struct.sphere** %5, align 8
  %286 = getelementptr inbounds %struct.sphere, %struct.sphere* %285, i32 0, i32 1
  %287 = load double, double* %286, align 8
  %288 = fdiv double %284, %287
  %289 = load %struct.spoint*, %struct.spoint** %6, align 8
  %290 = getelementptr inbounds %struct.spoint, %struct.spoint* %289, i32 0, i32 1
  %291 = getelementptr inbounds %struct.vec3, %struct.vec3* %290, i32 0, i32 0
  store double %288, double* %291, align 8
  %292 = load %struct.spoint*, %struct.spoint** %6, align 8
  %293 = getelementptr inbounds %struct.spoint, %struct.spoint* %292, i32 0, i32 0
  %294 = getelementptr inbounds %struct.vec3, %struct.vec3* %293, i32 0, i32 1
  %295 = load double, double* %294, align 8
  %296 = load %struct.sphere*, %struct.sphere** %5, align 8
  %297 = getelementptr inbounds %struct.sphere, %struct.sphere* %296, i32 0, i32 0
  %298 = getelementptr inbounds %struct.vec3, %struct.vec3* %297, i32 0, i32 1
  %299 = load double, double* %298, align 8
  %300 = fsub double %295, %299
  %301 = load %struct.sphere*, %struct.sphere** %5, align 8
  %302 = getelementptr inbounds %struct.sphere, %struct.sphere* %301, i32 0, i32 1
  %303 = load double, double* %302, align 8
  %304 = fdiv double %300, %303
  %305 = load %struct.spoint*, %struct.spoint** %6, align 8
  %306 = getelementptr inbounds %struct.spoint, %struct.spoint* %305, i32 0, i32 1
  %307 = getelementptr inbounds %struct.vec3, %struct.vec3* %306, i32 0, i32 1
  store double %304, double* %307, align 8
  %308 = load %struct.spoint*, %struct.spoint** %6, align 8
  %309 = getelementptr inbounds %struct.spoint, %struct.spoint* %308, i32 0, i32 0
  %310 = getelementptr inbounds %struct.vec3, %struct.vec3* %309, i32 0, i32 2
  %311 = load double, double* %310, align 8
  %312 = load %struct.sphere*, %struct.sphere** %5, align 8
  %313 = getelementptr inbounds %struct.sphere, %struct.sphere* %312, i32 0, i32 0
  %314 = getelementptr inbounds %struct.vec3, %struct.vec3* %313, i32 0, i32 2
  %315 = load double, double* %314, align 8
  %316 = fsub double %311, %315
  %317 = load %struct.sphere*, %struct.sphere** %5, align 8
  %318 = getelementptr inbounds %struct.sphere, %struct.sphere* %317, i32 0, i32 1
  %319 = load double, double* %318, align 8
  %320 = fdiv double %316, %319
  %321 = load %struct.spoint*, %struct.spoint** %6, align 8
  %322 = getelementptr inbounds %struct.spoint, %struct.spoint* %321, i32 0, i32 1
  %323 = getelementptr inbounds %struct.vec3, %struct.vec3* %322, i32 0, i32 2
  store double %320, double* %323, align 8
  %324 = load %struct.spoint*, %struct.spoint** %6, align 8
  %325 = getelementptr inbounds %struct.spoint, %struct.spoint* %324, i32 0, i32 2
  %326 = getelementptr inbounds %struct.ray, %struct.ray* %1, i32 0, i32 1
  %327 = load %struct.spoint*, %struct.spoint** %6, align 8
  %328 = getelementptr inbounds %struct.spoint, %struct.spoint* %327, i32 0, i32 1
  call void @reflect(%struct.vec3* sret %14, %struct.vec3* byval align 8 %326, %struct.vec3* byval align 8 %328)
  %329 = bitcast %struct.vec3* %325 to i8*
  %330 = bitcast %struct.vec3* %14 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %329, i8* align 8 %330, i64 24, i1 false)
  br label %331

; <label>:331:                                    ; preds = %230
  %332 = load %struct.spoint*, %struct.spoint** %6, align 8
  %333 = getelementptr inbounds %struct.spoint, %struct.spoint* %332, i32 0, i32 2
  %334 = getelementptr inbounds %struct.vec3, %struct.vec3* %333, i32 0, i32 0
  %335 = load double, double* %334, align 8
  %336 = load %struct.spoint*, %struct.spoint** %6, align 8
  %337 = getelementptr inbounds %struct.spoint, %struct.spoint* %336, i32 0, i32 2
  %338 = getelementptr inbounds %struct.vec3, %struct.vec3* %337, i32 0, i32 0
  %339 = load double, double* %338, align 8
  %340 = fmul double %335, %339
  %341 = load %struct.spoint*, %struct.spoint** %6, align 8
  %342 = getelementptr inbounds %struct.spoint, %struct.spoint* %341, i32 0, i32 2
  %343 = getelementptr inbounds %struct.vec3, %struct.vec3* %342, i32 0, i32 1
  %344 = load double, double* %343, align 8
  %345 = load %struct.spoint*, %struct.spoint** %6, align 8
  %346 = getelementptr inbounds %struct.spoint, %struct.spoint* %345, i32 0, i32 2
  %347 = getelementptr inbounds %struct.vec3, %struct.vec3* %346, i32 0, i32 1
  %348 = load double, double* %347, align 8
  %349 = fmul double %344, %348
  %350 = fadd double %340, %349
  %351 = load %struct.spoint*, %struct.spoint** %6, align 8
  %352 = getelementptr inbounds %struct.spoint, %struct.spoint* %351, i32 0, i32 2
  %353 = getelementptr inbounds %struct.vec3, %struct.vec3* %352, i32 0, i32 2
  %354 = load double, double* %353, align 8
  %355 = load %struct.spoint*, %struct.spoint** %6, align 8
  %356 = getelementptr inbounds %struct.spoint, %struct.spoint* %355, i32 0, i32 2
  %357 = getelementptr inbounds %struct.vec3, %struct.vec3* %356, i32 0, i32 2
  %358 = load double, double* %357, align 8
  %359 = fmul double %354, %358
  %360 = fadd double %350, %359
  %361 = call double @sqrt(double %360) #5
  store double %361, double* %15, align 8
  %362 = load double, double* %15, align 8
  %363 = load %struct.spoint*, %struct.spoint** %6, align 8
  %364 = getelementptr inbounds %struct.spoint, %struct.spoint* %363, i32 0, i32 2
  %365 = getelementptr inbounds %struct.vec3, %struct.vec3* %364, i32 0, i32 0
  %366 = load double, double* %365, align 8
  %367 = fdiv double %366, %362
  store double %367, double* %365, align 8
  %368 = load double, double* %15, align 8
  %369 = load %struct.spoint*, %struct.spoint** %6, align 8
  %370 = getelementptr inbounds %struct.spoint, %struct.spoint* %369, i32 0, i32 2
  %371 = getelementptr inbounds %struct.vec3, %struct.vec3* %370, i32 0, i32 1
  %372 = load double, double* %371, align 8
  %373 = fdiv double %372, %368
  store double %373, double* %371, align 8
  %374 = load double, double* %15, align 8
  %375 = load %struct.spoint*, %struct.spoint** %6, align 8
  %376 = getelementptr inbounds %struct.spoint, %struct.spoint* %375, i32 0, i32 2
  %377 = getelementptr inbounds %struct.vec3, %struct.vec3* %376, i32 0, i32 2
  %378 = load double, double* %377, align 8
  %379 = fdiv double %378, %374
  store double %379, double* %377, align 8
  br label %380

; <label>:380:                                    ; preds = %331
  br label %381

; <label>:381:                                    ; preds = %380, %209
  store i32 1, i32* %4, align 4
  br label %382

; <label>:382:                                    ; preds = %381, %208, %179
  %383 = load i32, i32* %4, align 4
  ret i32 %383
}

; Function Attrs: noinline nounwind optnone uwtable
define void @shade(%struct.vec3* noalias sret, %struct.sphere*, %struct.spoint*, i32) #0 {
  %5 = alloca %struct.sphere*, align 8
  %6 = alloca %struct.spoint*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.vec3, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca %struct.vec3, align 8
  %13 = alloca %struct.ray, align 8
  %14 = alloca %struct.sphere*, align 8
  %15 = alloca i32, align 4
  %16 = alloca double, align 8
  %17 = alloca %struct.ray, align 8
  %18 = alloca %struct.vec3, align 8
  %19 = alloca %struct.vec3, align 8
  store %struct.sphere* %1, %struct.sphere** %5, align 8
  store %struct.spoint* %2, %struct.spoint** %6, align 8
  store i32 %3, i32* %7, align 4
  %20 = bitcast %struct.vec3* %9 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %20, i8 0, i64 24, i1 false)
  store i32 0, i32* %8, align 4
  br label %21

; <label>:21:                                     ; preds = %271, %4
  %22 = load i32, i32* %8, align 4
  %23 = load i32, i32* @lnum, align 4
  %24 = icmp slt i32 %22, %23
  br i1 %24, label %25, label %274

; <label>:25:                                     ; preds = %21
  %26 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %27 = getelementptr inbounds %struct.sphere, %struct.sphere* %26, i32 0, i32 3
  %28 = load %struct.sphere*, %struct.sphere** %27, align 8
  store %struct.sphere* %28, %struct.sphere** %14, align 8
  store i32 0, i32* %15, align 4
  %29 = load i32, i32* %8, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %30
  %32 = getelementptr inbounds %struct.vec3, %struct.vec3* %31, i32 0, i32 0
  %33 = load double, double* %32, align 8
  %34 = load %struct.spoint*, %struct.spoint** %6, align 8
  %35 = getelementptr inbounds %struct.spoint, %struct.spoint* %34, i32 0, i32 0
  %36 = getelementptr inbounds %struct.vec3, %struct.vec3* %35, i32 0, i32 0
  %37 = load double, double* %36, align 8
  %38 = fsub double %33, %37
  %39 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  store double %38, double* %39, align 8
  %40 = load i32, i32* %8, align 4
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %41
  %43 = getelementptr inbounds %struct.vec3, %struct.vec3* %42, i32 0, i32 1
  %44 = load double, double* %43, align 8
  %45 = load %struct.spoint*, %struct.spoint** %6, align 8
  %46 = getelementptr inbounds %struct.spoint, %struct.spoint* %45, i32 0, i32 0
  %47 = getelementptr inbounds %struct.vec3, %struct.vec3* %46, i32 0, i32 1
  %48 = load double, double* %47, align 8
  %49 = fsub double %44, %48
  %50 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  store double %49, double* %50, align 8
  %51 = load i32, i32* %8, align 4
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %52
  %54 = getelementptr inbounds %struct.vec3, %struct.vec3* %53, i32 0, i32 2
  %55 = load double, double* %54, align 8
  %56 = load %struct.spoint*, %struct.spoint** %6, align 8
  %57 = getelementptr inbounds %struct.spoint, %struct.spoint* %56, i32 0, i32 0
  %58 = getelementptr inbounds %struct.vec3, %struct.vec3* %57, i32 0, i32 2
  %59 = load double, double* %58, align 8
  %60 = fsub double %55, %59
  %61 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  store double %60, double* %61, align 8
  %62 = getelementptr inbounds %struct.ray, %struct.ray* %13, i32 0, i32 0
  %63 = load %struct.spoint*, %struct.spoint** %6, align 8
  %64 = getelementptr inbounds %struct.spoint, %struct.spoint* %63, i32 0, i32 0
  %65 = bitcast %struct.vec3* %62 to i8*
  %66 = bitcast %struct.vec3* %64 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %65, i8* align 8 %66, i64 24, i1 false)
  %67 = getelementptr inbounds %struct.ray, %struct.ray* %13, i32 0, i32 1
  %68 = bitcast %struct.vec3* %67 to i8*
  %69 = bitcast %struct.vec3* %12 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %68, i8* align 8 %69, i64 24, i1 false)
  br label %70

; <label>:70:                                     ; preds = %78, %25
  %71 = load %struct.sphere*, %struct.sphere** %14, align 8
  %72 = icmp ne %struct.sphere* %71, null
  br i1 %72, label %73, label %82

; <label>:73:                                     ; preds = %70
  %74 = load %struct.sphere*, %struct.sphere** %14, align 8
  %75 = call i32 @ray_sphere(%struct.sphere* %74, %struct.ray* byval align 8 %13, %struct.spoint* null)
  %76 = icmp ne i32 %75, 0
  br i1 %76, label %77, label %78

; <label>:77:                                     ; preds = %73
  store i32 1, i32* %15, align 4
  br label %82

; <label>:78:                                     ; preds = %73
  %79 = load %struct.sphere*, %struct.sphere** %14, align 8
  %80 = getelementptr inbounds %struct.sphere, %struct.sphere* %79, i32 0, i32 3
  %81 = load %struct.sphere*, %struct.sphere** %80, align 8
  store %struct.sphere* %81, %struct.sphere** %14, align 8
  br label %70

; <label>:82:                                     ; preds = %77, %70
  %83 = load i32, i32* %15, align 4
  %84 = icmp ne i32 %83, 0
  br i1 %84, label %270, label %85

; <label>:85:                                     ; preds = %82
  br label %86

; <label>:86:                                     ; preds = %85
  %87 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %88 = load double, double* %87, align 8
  %89 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %90 = load double, double* %89, align 8
  %91 = fmul double %88, %90
  %92 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %93 = load double, double* %92, align 8
  %94 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %95 = load double, double* %94, align 8
  %96 = fmul double %93, %95
  %97 = fadd double %91, %96
  %98 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %99 = load double, double* %98, align 8
  %100 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %101 = load double, double* %100, align 8
  %102 = fmul double %99, %101
  %103 = fadd double %97, %102
  %104 = call double @sqrt(double %103) #5
  store double %104, double* %16, align 8
  %105 = load double, double* %16, align 8
  %106 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %107 = load double, double* %106, align 8
  %108 = fdiv double %107, %105
  store double %108, double* %106, align 8
  %109 = load double, double* %16, align 8
  %110 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %111 = load double, double* %110, align 8
  %112 = fdiv double %111, %109
  store double %112, double* %110, align 8
  %113 = load double, double* %16, align 8
  %114 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %115 = load double, double* %114, align 8
  %116 = fdiv double %115, %113
  store double %116, double* %114, align 8
  br label %117

; <label>:117:                                    ; preds = %86
  %118 = load %struct.spoint*, %struct.spoint** %6, align 8
  %119 = getelementptr inbounds %struct.spoint, %struct.spoint* %118, i32 0, i32 1
  %120 = getelementptr inbounds %struct.vec3, %struct.vec3* %119, i32 0, i32 0
  %121 = load double, double* %120, align 8
  %122 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %123 = load double, double* %122, align 8
  %124 = fmul double %121, %123
  %125 = load %struct.spoint*, %struct.spoint** %6, align 8
  %126 = getelementptr inbounds %struct.spoint, %struct.spoint* %125, i32 0, i32 1
  %127 = getelementptr inbounds %struct.vec3, %struct.vec3* %126, i32 0, i32 1
  %128 = load double, double* %127, align 8
  %129 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %130 = load double, double* %129, align 8
  %131 = fmul double %128, %130
  %132 = fadd double %124, %131
  %133 = load %struct.spoint*, %struct.spoint** %6, align 8
  %134 = getelementptr inbounds %struct.spoint, %struct.spoint* %133, i32 0, i32 1
  %135 = getelementptr inbounds %struct.vec3, %struct.vec3* %134, i32 0, i32 2
  %136 = load double, double* %135, align 8
  %137 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %138 = load double, double* %137, align 8
  %139 = fmul double %136, %138
  %140 = fadd double %132, %139
  %141 = fcmp ogt double %140, 0.000000e+00
  br i1 %141, label %142, label %166

; <label>:142:                                    ; preds = %117
  %143 = load %struct.spoint*, %struct.spoint** %6, align 8
  %144 = getelementptr inbounds %struct.spoint, %struct.spoint* %143, i32 0, i32 1
  %145 = getelementptr inbounds %struct.vec3, %struct.vec3* %144, i32 0, i32 0
  %146 = load double, double* %145, align 8
  %147 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %148 = load double, double* %147, align 8
  %149 = fmul double %146, %148
  %150 = load %struct.spoint*, %struct.spoint** %6, align 8
  %151 = getelementptr inbounds %struct.spoint, %struct.spoint* %150, i32 0, i32 1
  %152 = getelementptr inbounds %struct.vec3, %struct.vec3* %151, i32 0, i32 1
  %153 = load double, double* %152, align 8
  %154 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %155 = load double, double* %154, align 8
  %156 = fmul double %153, %155
  %157 = fadd double %149, %156
  %158 = load %struct.spoint*, %struct.spoint** %6, align 8
  %159 = getelementptr inbounds %struct.spoint, %struct.spoint* %158, i32 0, i32 1
  %160 = getelementptr inbounds %struct.vec3, %struct.vec3* %159, i32 0, i32 2
  %161 = load double, double* %160, align 8
  %162 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %163 = load double, double* %162, align 8
  %164 = fmul double %161, %163
  %165 = fadd double %157, %164
  br label %167

; <label>:166:                                    ; preds = %117
  br label %167

; <label>:167:                                    ; preds = %166, %142
  %168 = phi double [ %165, %142 ], [ 0.000000e+00, %166 ]
  store double %168, double* %11, align 8
  %169 = load %struct.sphere*, %struct.sphere** %5, align 8
  %170 = getelementptr inbounds %struct.sphere, %struct.sphere* %169, i32 0, i32 2
  %171 = getelementptr inbounds %struct.material, %struct.material* %170, i32 0, i32 1
  %172 = load double, double* %171, align 8
  %173 = fcmp ogt double %172, 0.000000e+00
  br i1 %173, label %174, label %231

; <label>:174:                                    ; preds = %167
  %175 = load %struct.spoint*, %struct.spoint** %6, align 8
  %176 = getelementptr inbounds %struct.spoint, %struct.spoint* %175, i32 0, i32 2
  %177 = getelementptr inbounds %struct.vec3, %struct.vec3* %176, i32 0, i32 0
  %178 = load double, double* %177, align 8
  %179 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %180 = load double, double* %179, align 8
  %181 = fmul double %178, %180
  %182 = load %struct.spoint*, %struct.spoint** %6, align 8
  %183 = getelementptr inbounds %struct.spoint, %struct.spoint* %182, i32 0, i32 2
  %184 = getelementptr inbounds %struct.vec3, %struct.vec3* %183, i32 0, i32 1
  %185 = load double, double* %184, align 8
  %186 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %187 = load double, double* %186, align 8
  %188 = fmul double %185, %187
  %189 = fadd double %181, %188
  %190 = load %struct.spoint*, %struct.spoint** %6, align 8
  %191 = getelementptr inbounds %struct.spoint, %struct.spoint* %190, i32 0, i32 2
  %192 = getelementptr inbounds %struct.vec3, %struct.vec3* %191, i32 0, i32 2
  %193 = load double, double* %192, align 8
  %194 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %195 = load double, double* %194, align 8
  %196 = fmul double %193, %195
  %197 = fadd double %189, %196
  %198 = fcmp ogt double %197, 0.000000e+00
  br i1 %198, label %199, label %223

; <label>:199:                                    ; preds = %174
  %200 = load %struct.spoint*, %struct.spoint** %6, align 8
  %201 = getelementptr inbounds %struct.spoint, %struct.spoint* %200, i32 0, i32 2
  %202 = getelementptr inbounds %struct.vec3, %struct.vec3* %201, i32 0, i32 0
  %203 = load double, double* %202, align 8
  %204 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %205 = load double, double* %204, align 8
  %206 = fmul double %203, %205
  %207 = load %struct.spoint*, %struct.spoint** %6, align 8
  %208 = getelementptr inbounds %struct.spoint, %struct.spoint* %207, i32 0, i32 2
  %209 = getelementptr inbounds %struct.vec3, %struct.vec3* %208, i32 0, i32 1
  %210 = load double, double* %209, align 8
  %211 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %212 = load double, double* %211, align 8
  %213 = fmul double %210, %212
  %214 = fadd double %206, %213
  %215 = load %struct.spoint*, %struct.spoint** %6, align 8
  %216 = getelementptr inbounds %struct.spoint, %struct.spoint* %215, i32 0, i32 2
  %217 = getelementptr inbounds %struct.vec3, %struct.vec3* %216, i32 0, i32 2
  %218 = load double, double* %217, align 8
  %219 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %220 = load double, double* %219, align 8
  %221 = fmul double %218, %220
  %222 = fadd double %214, %221
  br label %224

; <label>:223:                                    ; preds = %174
  br label %224

; <label>:224:                                    ; preds = %223, %199
  %225 = phi double [ %222, %199 ], [ 0.000000e+00, %223 ]
  %226 = load %struct.sphere*, %struct.sphere** %5, align 8
  %227 = getelementptr inbounds %struct.sphere, %struct.sphere* %226, i32 0, i32 2
  %228 = getelementptr inbounds %struct.material, %struct.material* %227, i32 0, i32 1
  %229 = load double, double* %228, align 8
  %230 = call double @pow(double %225, double %229) #5
  br label %232

; <label>:231:                                    ; preds = %167
  br label %232

; <label>:232:                                    ; preds = %231, %224
  %233 = phi double [ %230, %224 ], [ 0.000000e+00, %231 ]
  store double %233, double* %10, align 8
  %234 = load double, double* %11, align 8
  %235 = load %struct.sphere*, %struct.sphere** %5, align 8
  %236 = getelementptr inbounds %struct.sphere, %struct.sphere* %235, i32 0, i32 2
  %237 = getelementptr inbounds %struct.material, %struct.material* %236, i32 0, i32 0
  %238 = getelementptr inbounds %struct.vec3, %struct.vec3* %237, i32 0, i32 0
  %239 = load double, double* %238, align 8
  %240 = fmul double %234, %239
  %241 = load double, double* %10, align 8
  %242 = fadd double %240, %241
  %243 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 0
  %244 = load double, double* %243, align 8
  %245 = fadd double %244, %242
  store double %245, double* %243, align 8
  %246 = load double, double* %11, align 8
  %247 = load %struct.sphere*, %struct.sphere** %5, align 8
  %248 = getelementptr inbounds %struct.sphere, %struct.sphere* %247, i32 0, i32 2
  %249 = getelementptr inbounds %struct.material, %struct.material* %248, i32 0, i32 0
  %250 = getelementptr inbounds %struct.vec3, %struct.vec3* %249, i32 0, i32 1
  %251 = load double, double* %250, align 8
  %252 = fmul double %246, %251
  %253 = load double, double* %10, align 8
  %254 = fadd double %252, %253
  %255 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 1
  %256 = load double, double* %255, align 8
  %257 = fadd double %256, %254
  store double %257, double* %255, align 8
  %258 = load double, double* %11, align 8
  %259 = load %struct.sphere*, %struct.sphere** %5, align 8
  %260 = getelementptr inbounds %struct.sphere, %struct.sphere* %259, i32 0, i32 2
  %261 = getelementptr inbounds %struct.material, %struct.material* %260, i32 0, i32 0
  %262 = getelementptr inbounds %struct.vec3, %struct.vec3* %261, i32 0, i32 2
  %263 = load double, double* %262, align 8
  %264 = fmul double %258, %263
  %265 = load double, double* %10, align 8
  %266 = fadd double %264, %265
  %267 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 2
  %268 = load double, double* %267, align 8
  %269 = fadd double %268, %266
  store double %269, double* %267, align 8
  br label %270

; <label>:270:                                    ; preds = %232, %82
  br label %271

; <label>:271:                                    ; preds = %270
  %272 = load i32, i32* %8, align 4
  %273 = add nsw i32 %272, 1
  store i32 %273, i32* %8, align 4
  br label %21

; <label>:274:                                    ; preds = %21
  %275 = load %struct.sphere*, %struct.sphere** %5, align 8
  %276 = getelementptr inbounds %struct.sphere, %struct.sphere* %275, i32 0, i32 2
  %277 = getelementptr inbounds %struct.material, %struct.material* %276, i32 0, i32 2
  %278 = load double, double* %277, align 8
  %279 = fcmp ogt double %278, 0.000000e+00
  br i1 %279, label %280, label %337

; <label>:280:                                    ; preds = %274
  %281 = getelementptr inbounds %struct.ray, %struct.ray* %17, i32 0, i32 0
  %282 = load %struct.spoint*, %struct.spoint** %6, align 8
  %283 = getelementptr inbounds %struct.spoint, %struct.spoint* %282, i32 0, i32 0
  %284 = bitcast %struct.vec3* %281 to i8*
  %285 = bitcast %struct.vec3* %283 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %284, i8* align 8 %285, i64 24, i1 false)
  %286 = getelementptr inbounds %struct.ray, %struct.ray* %17, i32 0, i32 1
  %287 = load %struct.spoint*, %struct.spoint** %6, align 8
  %288 = getelementptr inbounds %struct.spoint, %struct.spoint* %287, i32 0, i32 2
  %289 = bitcast %struct.vec3* %286 to i8*
  %290 = bitcast %struct.vec3* %288 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %289, i8* align 8 %290, i64 24, i1 false)
  %291 = getelementptr inbounds %struct.ray, %struct.ray* %17, i32 0, i32 1
  %292 = getelementptr inbounds %struct.vec3, %struct.vec3* %291, i32 0, i32 0
  %293 = load double, double* %292, align 8
  %294 = fmul double %293, 1.000000e+03
  store double %294, double* %292, align 8
  %295 = getelementptr inbounds %struct.ray, %struct.ray* %17, i32 0, i32 1
  %296 = getelementptr inbounds %struct.vec3, %struct.vec3* %295, i32 0, i32 1
  %297 = load double, double* %296, align 8
  %298 = fmul double %297, 1.000000e+03
  store double %298, double* %296, align 8
  %299 = getelementptr inbounds %struct.ray, %struct.ray* %17, i32 0, i32 1
  %300 = getelementptr inbounds %struct.vec3, %struct.vec3* %299, i32 0, i32 2
  %301 = load double, double* %300, align 8
  %302 = fmul double %301, 1.000000e+03
  store double %302, double* %300, align 8
  %303 = load i32, i32* %7, align 4
  %304 = add nsw i32 %303, 1
  call void @trace(%struct.vec3* sret %19, %struct.ray* byval align 8 %17, i32 %304)
  %305 = bitcast %struct.vec3* %18 to i8*
  %306 = bitcast %struct.vec3* %19 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %305, i8* align 8 %306, i64 24, i1 false)
  %307 = getelementptr inbounds %struct.vec3, %struct.vec3* %18, i32 0, i32 0
  %308 = load double, double* %307, align 8
  %309 = load %struct.sphere*, %struct.sphere** %5, align 8
  %310 = getelementptr inbounds %struct.sphere, %struct.sphere* %309, i32 0, i32 2
  %311 = getelementptr inbounds %struct.material, %struct.material* %310, i32 0, i32 2
  %312 = load double, double* %311, align 8
  %313 = fmul double %308, %312
  %314 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 0
  %315 = load double, double* %314, align 8
  %316 = fadd double %315, %313
  store double %316, double* %314, align 8
  %317 = getelementptr inbounds %struct.vec3, %struct.vec3* %18, i32 0, i32 1
  %318 = load double, double* %317, align 8
  %319 = load %struct.sphere*, %struct.sphere** %5, align 8
  %320 = getelementptr inbounds %struct.sphere, %struct.sphere* %319, i32 0, i32 2
  %321 = getelementptr inbounds %struct.material, %struct.material* %320, i32 0, i32 2
  %322 = load double, double* %321, align 8
  %323 = fmul double %318, %322
  %324 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 1
  %325 = load double, double* %324, align 8
  %326 = fadd double %325, %323
  store double %326, double* %324, align 8
  %327 = getelementptr inbounds %struct.vec3, %struct.vec3* %18, i32 0, i32 2
  %328 = load double, double* %327, align 8
  %329 = load %struct.sphere*, %struct.sphere** %5, align 8
  %330 = getelementptr inbounds %struct.sphere, %struct.sphere* %329, i32 0, i32 2
  %331 = getelementptr inbounds %struct.material, %struct.material* %330, i32 0, i32 2
  %332 = load double, double* %331, align 8
  %333 = fmul double %328, %332
  %334 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 2
  %335 = load double, double* %334, align 8
  %336 = fadd double %335, %333
  store double %336, double* %334, align 8
  br label %337

; <label>:337:                                    ; preds = %280, %274
  %338 = bitcast %struct.vec3* %0 to i8*
  %339 = bitcast %struct.vec3* %9 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %338, i8* align 8 %339, i64 24, i1 false)
  ret void
}

; Function Attrs: nounwind
declare double @sqrt(double) #2

; Function Attrs: nounwind
declare double @pow(double, double) #2

; Function Attrs: noinline nounwind optnone uwtable
define void @reflect(%struct.vec3* noalias sret, %struct.vec3* byval align 8, %struct.vec3* byval align 8) #0 {
  %4 = alloca %struct.vec3, align 8
  %5 = alloca double, align 8
  %6 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %7 = load double, double* %6, align 8
  %8 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %9 = load double, double* %8, align 8
  %10 = fmul double %7, %9
  %11 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %12 = load double, double* %11, align 8
  %13 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %14 = load double, double* %13, align 8
  %15 = fmul double %12, %14
  %16 = fadd double %10, %15
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %18 = load double, double* %17, align 8
  %19 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %20 = load double, double* %19, align 8
  %21 = fmul double %18, %20
  %22 = fadd double %16, %21
  store double %22, double* %5, align 8
  %23 = load double, double* %5, align 8
  %24 = fmul double 2.000000e+00, %23
  %25 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %26 = load double, double* %25, align 8
  %27 = fmul double %24, %26
  %28 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %29 = load double, double* %28, align 8
  %30 = fsub double %27, %29
  %31 = fsub double -0.000000e+00, %30
  %32 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 0
  store double %31, double* %32, align 8
  %33 = load double, double* %5, align 8
  %34 = fmul double 2.000000e+00, %33
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %36 = load double, double* %35, align 8
  %37 = fmul double %34, %36
  %38 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %39 = load double, double* %38, align 8
  %40 = fsub double %37, %39
  %41 = fsub double -0.000000e+00, %40
  %42 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 1
  store double %41, double* %42, align 8
  %43 = load double, double* %5, align 8
  %44 = fmul double 2.000000e+00, %43
  %45 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %46 = load double, double* %45, align 8
  %47 = fmul double %44, %46
  %48 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %49 = load double, double* %48, align 8
  %50 = fsub double %47, %49
  %51 = fsub double -0.000000e+00, %50
  %52 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 2
  store double %51, double* %52, align 8
  %53 = bitcast %struct.vec3* %0 to i8*
  %54 = bitcast %struct.vec3* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %53, i8* align 8 %54, i64 24, i1 false)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define void @cross_product(%struct.vec3* noalias sret, %struct.vec3* byval align 8, %struct.vec3* byval align 8) #0 {
  %4 = alloca %struct.vec3, align 8
  %5 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %6 = load double, double* %5, align 8
  %7 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %8 = load double, double* %7, align 8
  %9 = fmul double %6, %8
  %10 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %11 = load double, double* %10, align 8
  %12 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %13 = load double, double* %12, align 8
  %14 = fmul double %11, %13
  %15 = fsub double %9, %14
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 0
  store double %15, double* %16, align 8
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %18 = load double, double* %17, align 8
  %19 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %20 = load double, double* %19, align 8
  %21 = fmul double %18, %20
  %22 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %23 = load double, double* %22, align 8
  %24 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %25 = load double, double* %24, align 8
  %26 = fmul double %23, %25
  %27 = fsub double %21, %26
  %28 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 1
  store double %27, double* %28, align 8
  %29 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %30 = load double, double* %29, align 8
  %31 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %32 = load double, double* %31, align 8
  %33 = fmul double %30, %32
  %34 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %35 = load double, double* %34, align 8
  %36 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %37 = load double, double* %36, align 8
  %38 = fmul double %35, %37
  %39 = fsub double %33, %38
  %40 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i32 0, i32 2
  store double %39, double* %40, align 8
  %41 = bitcast %struct.vec3* %0 to i8*
  %42 = bitcast %struct.vec3* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %41, i8* align 8 %42, i64 24, i1 false)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define void @get_sample_pos(%struct.vec3* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca %struct.vec3, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca %struct.vec3, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  store double 2.000000e+00, double* %9, align 8
  %12 = load i32, i32* @xres, align 4
  %13 = sitofp i32 %12 to double
  %14 = load double, double* @aspect, align 8
  %15 = fdiv double %13, %14
  store double %15, double* %10, align 8
  %16 = load double, double* @get_sample_pos.sf, align 8
  %17 = fcmp oeq double %16, 0.000000e+00
  br i1 %17, label %18, label %22

; <label>:18:                                     ; preds = %4
  %19 = load i32, i32* @xres, align 4
  %20 = sitofp i32 %19 to double
  %21 = fdiv double 2.000000e+00, %20
  store double %21, double* @get_sample_pos.sf, align 8
  br label %22

; <label>:22:                                     ; preds = %18, %4
  %23 = load i32, i32* %5, align 4
  %24 = sitofp i32 %23 to double
  %25 = load i32, i32* @xres, align 4
  %26 = sitofp i32 %25 to double
  %27 = fdiv double %24, %26
  %28 = fsub double %27, 5.000000e-01
  %29 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 0
  store double %28, double* %29, align 8
  %30 = load i32, i32* %6, align 4
  %31 = sitofp i32 %30 to double
  %32 = load i32, i32* @yres, align 4
  %33 = sitofp i32 %32 to double
  %34 = fdiv double %31, %33
  %35 = fsub double %34, 6.500000e-01
  %36 = fsub double -0.000000e+00, %35
  %37 = load double, double* @aspect, align 8
  %38 = fdiv double %36, %37
  %39 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 1
  store double %38, double* %39, align 8
  %40 = load i32, i32* %7, align 4
  %41 = icmp ne i32 %40, 0
  br i1 %41, label %42, label %62

; <label>:42:                                     ; preds = %22
  %43 = load i32, i32* %5, align 4
  %44 = load i32, i32* %6, align 4
  %45 = load i32, i32* %7, align 4
  call void @jitter(%struct.vec3* sret %11, i32 %43, i32 %44, i32 %45)
  %46 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %47 = load double, double* %46, align 8
  %48 = load double, double* @get_sample_pos.sf, align 8
  %49 = fmul double %47, %48
  %50 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 0
  %51 = load double, double* %50, align 8
  %52 = fadd double %51, %49
  store double %52, double* %50, align 8
  %53 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %54 = load double, double* %53, align 8
  %55 = load double, double* @get_sample_pos.sf, align 8
  %56 = fmul double %54, %55
  %57 = load double, double* @aspect, align 8
  %58 = fdiv double %56, %57
  %59 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 1
  %60 = load double, double* %59, align 8
  %61 = fadd double %60, %58
  store double %61, double* %59, align 8
  br label %62

; <label>:62:                                     ; preds = %42, %22
  %63 = bitcast %struct.vec3* %0 to i8*
  %64 = bitcast %struct.vec3* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %63, i8* align 8 %64, i64 24, i1 false)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define void @jitter(%struct.vec3* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca %struct.vec3, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  %9 = load i32, i32* %5, align 4
  %10 = load i32, i32* %6, align 4
  %11 = shl i32 %10, 2
  %12 = add nsw i32 %9, %11
  %13 = load i32, i32* %5, align 4
  %14 = load i32, i32* %7, align 4
  %15 = add nsw i32 %13, %14
  %16 = and i32 %15, 1023
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = add nsw i32 %12, %19
  %21 = and i32 %20, 1023
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %22
  %24 = getelementptr inbounds %struct.vec3, %struct.vec3* %23, i32 0, i32 0
  %25 = load double, double* %24, align 8
  %26 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 0
  store double %25, double* %26, align 8
  %27 = load i32, i32* %6, align 4
  %28 = load i32, i32* %5, align 4
  %29 = shl i32 %28, 2
  %30 = add nsw i32 %27, %29
  %31 = load i32, i32* %6, align 4
  %32 = load i32, i32* %7, align 4
  %33 = add nsw i32 %31, %32
  %34 = and i32 %33, 1023
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %35
  %37 = load i32, i32* %36, align 4
  %38 = add nsw i32 %30, %37
  %39 = and i32 %38, 1023
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %40
  %42 = getelementptr inbounds %struct.vec3, %struct.vec3* %41, i32 0, i32 1
  %43 = load double, double* %42, align 8
  %44 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i32 0, i32 1
  store double %43, double* %44, align 8
  %45 = bitcast %struct.vec3* %0 to i8*
  %46 = bitcast %struct.vec3* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %45, i8* align 8 %46, i64 24, i1 false)
  ret void
}

declare i8* @fgets(i8*, i32, %struct._IO_FILE*) #1

; Function Attrs: nounwind
declare i8* @strtok(i8*, i8*) #2

; Function Attrs: nounwind readonly
declare double @atof(i8*) #3

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval*, %struct.timezone*) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #4

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { nounwind }
attributes #6 = { nounwind readonly }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
