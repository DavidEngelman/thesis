; ModuleID = 'c-ray-f-2.c'
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

@xres = dso_local global i32 800, align 4
@yres = dso_local global i32 600, align 4
@aspect = dso_local global double 0x3FF55554FBDAD752, align 8
@lnum = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [363 x i8] c"Usage: c-ray-f [options]\0A  Reads a scene file from stdin, writes the image to stdout, and stats to stderr.\0A\0AOptions:\0A  -s WxH     where W is the width and H the height of the image\0A  -r <rays>  shoot <rays> rays per pixel (antialiasing)\0A  -i <file>  read from <file> instead of stdin\0A  -o <file>  write to <file> instead of stdout\0A  -h         this help screen\0A\0A\00", align 1
@usage = dso_local global i8* getelementptr inbounds ([363 x i8], [363 x i8]* @.str, i32 0, i32 0), align 8
@stdin = external dso_local global %struct._IO_FILE*, align 8
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str.1 = private unnamed_addr constant [6 x i8] c"scene\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"rendered_scene\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.5 = private unnamed_addr constant [31 x i8] c"pixel buffer allocation failed\00", align 1
@urand = common dso_local global [1024 x %struct.vec3] zeroinitializer, align 16
@irand = common dso_local global [1024 x i32] zeroinitializer, align 16
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.6 = private unnamed_addr constant [48 x i8] c"Rendering took: %lu seconds (%lu milliseconds)\0A\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"P6\0A%d %d\0A255\0A\00", align 1
@obj_list = common dso_local global %struct.sphere* null, align 8
@lights = common dso_local global [16 x %struct.vec3] zeroinitializer, align 16
@get_primary_ray.j = private unnamed_addr constant %struct.vec3 { double 0.000000e+00, double 1.000000e+00, double 0.000000e+00 }, align 8
@cam = common dso_local global %struct.camera zeroinitializer, align 8
@get_sample_pos.sf = internal global double 0.000000e+00, align 8
@.str.8 = private unnamed_addr constant [4 x i8] c" \09\0A\00", align 1
@.str.9 = private unnamed_addr constant [18 x i8] c"unknown type: %c\0A\00", align 1
@get_msec.timeval = internal global %struct.timeval zeroinitializer, align 8
@get_msec.first_timeval = internal global %struct.timeval zeroinitializer, align 8

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
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

declare dso_local %struct._IO_FILE* @fopen(i8*, i8*) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare dso_local void @perror(i8*) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @load_scene(%struct._IO_FILE*) #0 {
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
declare dso_local i32 @rand() #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @get_msec() #0 {
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
define dso_local void @render(i32, i32, i32*, i32) #0 {
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

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

declare dso_local i32 @fputc(i32, %struct._IO_FILE*) #1

declare dso_local i32 @fflush(%struct._IO_FILE*) #1

declare dso_local i32 @fclose(%struct._IO_FILE*) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @trace(%struct.vec3* noalias sret, %struct.ray* byval align 8, i32) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.spoint, align 8
  %6 = alloca %struct.spoint, align 8
  %7 = alloca %struct.sphere*, align 8
  %8 = alloca %struct.sphere*, align 8
  %9 = alloca %struct.vec3, align 8
  store i32 %2, i32* %4, align 4
  store %struct.sphere* null, %struct.sphere** %7, align 8
  %10 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %11 = getelementptr inbounds %struct.sphere, %struct.sphere* %10, i32 0, i32 3
  %12 = load %struct.sphere*, %struct.sphere** %11, align 8
  store %struct.sphere* %12, %struct.sphere** %8, align 8
  %13 = load i32, i32* %4, align 4
  %14 = icmp sge i32 %13, 5
  br i1 %14, label %15, label %19

; <label>:15:                                     ; preds = %3
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  store double 0.000000e+00, double* %16, align 8
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double 0.000000e+00, double* %17, align 8
  %18 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double 0.000000e+00, double* %18, align 8
  br label %58

; <label>:19:                                     ; preds = %3
  br label %20

; <label>:20:                                     ; preds = %41, %19
  %21 = load %struct.sphere*, %struct.sphere** %8, align 8
  %22 = icmp ne %struct.sphere* %21, null
  br i1 %22, label %23, label %45

; <label>:23:                                     ; preds = %20
  %24 = load %struct.sphere*, %struct.sphere** %8, align 8
  %25 = call i32 @ray_sphere(%struct.sphere* %24, %struct.ray* byval align 8 %1, %struct.spoint* %5)
  %26 = icmp ne i32 %25, 0
  br i1 %26, label %27, label %41

; <label>:27:                                     ; preds = %23
  %28 = load %struct.sphere*, %struct.sphere** %7, align 8
  %29 = icmp ne %struct.sphere* %28, null
  br i1 %29, label %30, label %36

; <label>:30:                                     ; preds = %27
  %31 = getelementptr inbounds %struct.spoint, %struct.spoint* %5, i32 0, i32 3
  %32 = load double, double* %31, align 8
  %33 = getelementptr inbounds %struct.spoint, %struct.spoint* %6, i32 0, i32 3
  %34 = load double, double* %33, align 8
  %35 = fcmp olt double %32, %34
  br i1 %35, label %36, label %40

; <label>:36:                                     ; preds = %30, %27
  %37 = load %struct.sphere*, %struct.sphere** %8, align 8
  store %struct.sphere* %37, %struct.sphere** %7, align 8
  %38 = bitcast %struct.spoint* %6 to i8*
  %39 = bitcast %struct.spoint* %5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %38, i8* align 8 %39, i64 80, i1 false)
  br label %40

; <label>:40:                                     ; preds = %36, %30
  br label %41

; <label>:41:                                     ; preds = %40, %23
  %42 = load %struct.sphere*, %struct.sphere** %8, align 8
  %43 = getelementptr inbounds %struct.sphere, %struct.sphere* %42, i32 0, i32 3
  %44 = load %struct.sphere*, %struct.sphere** %43, align 8
  store %struct.sphere* %44, %struct.sphere** %8, align 8
  br label %20

; <label>:45:                                     ; preds = %20
  %46 = load %struct.sphere*, %struct.sphere** %7, align 8
  %47 = icmp ne %struct.sphere* %46, null
  br i1 %47, label %48, label %53

; <label>:48:                                     ; preds = %45
  %49 = load %struct.sphere*, %struct.sphere** %7, align 8
  %50 = load i32, i32* %4, align 4
  call void @shade(%struct.vec3* sret %9, %struct.sphere* %49, %struct.spoint* %6, i32 %50)
  %51 = bitcast %struct.vec3* %0 to i8*
  %52 = bitcast %struct.vec3* %9 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %51, i8* align 8 %52, i64 24, i1 false)
  br label %57

; <label>:53:                                     ; preds = %45
  %54 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  store double 0.000000e+00, double* %54, align 8
  %55 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double 0.000000e+00, double* %55, align 8
  %56 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double 0.000000e+00, double* %56, align 8
  br label %57

; <label>:57:                                     ; preds = %53, %48
  br label %58

; <label>:58:                                     ; preds = %57, %15
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @get_primary_ray(%struct.ray* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca [3 x [3 x float]], align 16
  %9 = alloca %struct.vec3, align 8
  %10 = alloca %struct.vec3, align 8
  %11 = alloca %struct.vec3, align 8
  %12 = alloca %struct.vec3, align 8
  %13 = alloca %struct.vec3, align 8
  %14 = alloca %struct.vec3, align 8
  %15 = alloca double, align 8
  %16 = alloca %struct.vec3, align 8
  %17 = alloca %struct.vec3, align 8
  %18 = alloca %struct.vec3, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  %19 = bitcast %struct.vec3* %10 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %19, i8* align 8 bitcast (%struct.vec3* @get_primary_ray.j to i8*), i64 24, i1 false)
  %20 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 0), align 8
  %21 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 0), align 8
  %22 = fsub double %20, %21
  %23 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  store double %22, double* %23, align 8
  %24 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 1), align 8
  %25 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 1), align 8
  %26 = fsub double %24, %25
  %27 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  store double %26, double* %27, align 8
  %28 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 1, i32 2), align 8
  %29 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 2), align 8
  %30 = fsub double %28, %29
  %31 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  store double %30, double* %31, align 8
  br label %32

; <label>:32:                                     ; preds = %4
  %33 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %34 = load double, double* %33, align 8
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %36 = load double, double* %35, align 8
  %37 = fmul double %34, %36
  %38 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %39 = load double, double* %38, align 8
  %40 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %41 = load double, double* %40, align 8
  %42 = fmul double %39, %41
  %43 = fadd double %37, %42
  %44 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %45 = load double, double* %44, align 8
  %46 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %47 = load double, double* %46, align 8
  %48 = fmul double %45, %47
  %49 = fadd double %43, %48
  %50 = call double @sqrt(double %49) #5
  store double %50, double* %15, align 8
  %51 = load double, double* %15, align 8
  %52 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %53 = load double, double* %52, align 8
  %54 = fdiv double %53, %51
  store double %54, double* %52, align 8
  %55 = load double, double* %15, align 8
  %56 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %57 = load double, double* %56, align 8
  %58 = fdiv double %57, %55
  store double %58, double* %56, align 8
  %59 = load double, double* %15, align 8
  %60 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %61 = load double, double* %60, align 8
  %62 = fdiv double %61, %59
  store double %62, double* %60, align 8
  br label %63

; <label>:63:                                     ; preds = %32
  call void @cross_product(%struct.vec3* sret %16, %struct.vec3* byval align 8 %10, %struct.vec3* byval align 8 %11)
  %64 = bitcast %struct.vec3* %9 to i8*
  %65 = bitcast %struct.vec3* %16 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %64, i8* align 8 %65, i64 24, i1 false)
  call void @cross_product(%struct.vec3* sret %17, %struct.vec3* byval align 8 %11, %struct.vec3* byval align 8 %9)
  %66 = bitcast %struct.vec3* %10 to i8*
  %67 = bitcast %struct.vec3* %17 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %66, i8* align 8 %67, i64 24, i1 false)
  %68 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 0
  %69 = load double, double* %68, align 8
  %70 = fptrunc double %69 to float
  %71 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %72 = getelementptr inbounds [3 x float], [3 x float]* %71, i64 0, i64 0
  store float %70, float* %72, align 16
  %73 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 0
  %74 = load double, double* %73, align 8
  %75 = fptrunc double %74 to float
  %76 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %77 = getelementptr inbounds [3 x float], [3 x float]* %76, i64 0, i64 1
  store float %75, float* %77, align 4
  %78 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %79 = load double, double* %78, align 8
  %80 = fptrunc double %79 to float
  %81 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %82 = getelementptr inbounds [3 x float], [3 x float]* %81, i64 0, i64 2
  store float %80, float* %82, align 8
  %83 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 1
  %84 = load double, double* %83, align 8
  %85 = fptrunc double %84 to float
  %86 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %87 = getelementptr inbounds [3 x float], [3 x float]* %86, i64 0, i64 0
  store float %85, float* %87, align 4
  %88 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 1
  %89 = load double, double* %88, align 8
  %90 = fptrunc double %89 to float
  %91 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %92 = getelementptr inbounds [3 x float], [3 x float]* %91, i64 0, i64 1
  store float %90, float* %92, align 4
  %93 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %94 = load double, double* %93, align 8
  %95 = fptrunc double %94 to float
  %96 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %97 = getelementptr inbounds [3 x float], [3 x float]* %96, i64 0, i64 2
  store float %95, float* %97, align 4
  %98 = getelementptr inbounds %struct.vec3, %struct.vec3* %9, i32 0, i32 2
  %99 = load double, double* %98, align 8
  %100 = fptrunc double %99 to float
  %101 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %102 = getelementptr inbounds [3 x float], [3 x float]* %101, i64 0, i64 0
  store float %100, float* %102, align 8
  %103 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 2
  %104 = load double, double* %103, align 8
  %105 = fptrunc double %104 to float
  %106 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %107 = getelementptr inbounds [3 x float], [3 x float]* %106, i64 0, i64 1
  store float %105, float* %107, align 4
  %108 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %109 = load double, double* %108, align 8
  %110 = fptrunc double %109 to float
  %111 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %112 = getelementptr inbounds [3 x float], [3 x float]* %111, i64 0, i64 2
  store float %110, float* %112, align 8
  %113 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %114 = getelementptr inbounds %struct.vec3, %struct.vec3* %113, i32 0, i32 2
  store double 0.000000e+00, double* %114, align 8
  %115 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %116 = getelementptr inbounds %struct.vec3, %struct.vec3* %115, i32 0, i32 1
  store double 0.000000e+00, double* %116, align 8
  %117 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %118 = getelementptr inbounds %struct.vec3, %struct.vec3* %117, i32 0, i32 0
  store double 0.000000e+00, double* %118, align 8
  %119 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %120 = load i32, i32* %5, align 4
  %121 = load i32, i32* %6, align 4
  %122 = load i32, i32* %7, align 4
  call void @get_sample_pos(%struct.vec3* sret %18, i32 %120, i32 %121, i32 %122)
  %123 = bitcast %struct.vec3* %119 to i8*
  %124 = bitcast %struct.vec3* %18 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %123, i8* align 8 %124, i64 24, i1 false)
  %125 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %126 = getelementptr inbounds %struct.vec3, %struct.vec3* %125, i32 0, i32 2
  store double 0x40045F306F4445A0, double* %126, align 8
  %127 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %128 = getelementptr inbounds %struct.vec3, %struct.vec3* %127, i32 0, i32 0
  %129 = load double, double* %128, align 8
  %130 = fmul double %129, 1.000000e+03
  store double %130, double* %128, align 8
  %131 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %132 = getelementptr inbounds %struct.vec3, %struct.vec3* %131, i32 0, i32 1
  %133 = load double, double* %132, align 8
  %134 = fmul double %133, 1.000000e+03
  store double %134, double* %132, align 8
  %135 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %136 = getelementptr inbounds %struct.vec3, %struct.vec3* %135, i32 0, i32 2
  %137 = load double, double* %136, align 8
  %138 = fmul double %137, 1.000000e+03
  store double %138, double* %136, align 8
  %139 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %140 = getelementptr inbounds %struct.vec3, %struct.vec3* %139, i32 0, i32 0
  %141 = load double, double* %140, align 8
  %142 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %143 = getelementptr inbounds %struct.vec3, %struct.vec3* %142, i32 0, i32 0
  %144 = load double, double* %143, align 8
  %145 = fadd double %141, %144
  %146 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  store double %145, double* %146, align 8
  %147 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %148 = getelementptr inbounds %struct.vec3, %struct.vec3* %147, i32 0, i32 1
  %149 = load double, double* %148, align 8
  %150 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %151 = getelementptr inbounds %struct.vec3, %struct.vec3* %150, i32 0, i32 1
  %152 = load double, double* %151, align 8
  %153 = fadd double %149, %152
  %154 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  store double %153, double* %154, align 8
  %155 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %156 = getelementptr inbounds %struct.vec3, %struct.vec3* %155, i32 0, i32 2
  %157 = load double, double* %156, align 8
  %158 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %159 = getelementptr inbounds %struct.vec3, %struct.vec3* %158, i32 0, i32 2
  %160 = load double, double* %159, align 8
  %161 = fadd double %157, %160
  %162 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  store double %161, double* %162, align 8
  %163 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %164 = load double, double* %163, align 8
  %165 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %166 = getelementptr inbounds [3 x float], [3 x float]* %165, i64 0, i64 0
  %167 = load float, float* %166, align 16
  %168 = fpext float %167 to double
  %169 = fmul double %164, %168
  %170 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %171 = load double, double* %170, align 8
  %172 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %173 = getelementptr inbounds [3 x float], [3 x float]* %172, i64 0, i64 1
  %174 = load float, float* %173, align 4
  %175 = fpext float %174 to double
  %176 = fmul double %171, %175
  %177 = fadd double %169, %176
  %178 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %179 = load double, double* %178, align 8
  %180 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %181 = getelementptr inbounds [3 x float], [3 x float]* %180, i64 0, i64 2
  %182 = load float, float* %181, align 8
  %183 = fpext float %182 to double
  %184 = fmul double %179, %183
  %185 = fadd double %177, %184
  %186 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 0
  store double %185, double* %186, align 8
  %187 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %188 = load double, double* %187, align 8
  %189 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %190 = getelementptr inbounds [3 x float], [3 x float]* %189, i64 0, i64 0
  %191 = load float, float* %190, align 4
  %192 = fpext float %191 to double
  %193 = fmul double %188, %192
  %194 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %195 = load double, double* %194, align 8
  %196 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %197 = getelementptr inbounds [3 x float], [3 x float]* %196, i64 0, i64 1
  %198 = load float, float* %197, align 4
  %199 = fpext float %198 to double
  %200 = fmul double %195, %199
  %201 = fadd double %193, %200
  %202 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %203 = load double, double* %202, align 8
  %204 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %205 = getelementptr inbounds [3 x float], [3 x float]* %204, i64 0, i64 2
  %206 = load float, float* %205, align 4
  %207 = fpext float %206 to double
  %208 = fmul double %203, %207
  %209 = fadd double %201, %208
  %210 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 1
  store double %209, double* %210, align 8
  %211 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 0
  %212 = load double, double* %211, align 8
  %213 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %214 = getelementptr inbounds [3 x float], [3 x float]* %213, i64 0, i64 0
  %215 = load float, float* %214, align 8
  %216 = fpext float %215 to double
  %217 = fmul double %212, %216
  %218 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 1
  %219 = load double, double* %218, align 8
  %220 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %221 = getelementptr inbounds [3 x float], [3 x float]* %220, i64 0, i64 1
  %222 = load float, float* %221, align 4
  %223 = fpext float %222 to double
  %224 = fmul double %219, %223
  %225 = fadd double %217, %224
  %226 = getelementptr inbounds %struct.vec3, %struct.vec3* %12, i32 0, i32 2
  %227 = load double, double* %226, align 8
  %228 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %229 = getelementptr inbounds [3 x float], [3 x float]* %228, i64 0, i64 2
  %230 = load float, float* %229, align 8
  %231 = fpext float %230 to double
  %232 = fmul double %227, %231
  %233 = fadd double %225, %232
  %234 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 2
  store double %233, double* %234, align 8
  %235 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %236 = getelementptr inbounds %struct.vec3, %struct.vec3* %235, i32 0, i32 0
  %237 = load double, double* %236, align 8
  %238 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %239 = getelementptr inbounds [3 x float], [3 x float]* %238, i64 0, i64 0
  %240 = load float, float* %239, align 16
  %241 = fpext float %240 to double
  %242 = fmul double %237, %241
  %243 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %244 = getelementptr inbounds %struct.vec3, %struct.vec3* %243, i32 0, i32 1
  %245 = load double, double* %244, align 8
  %246 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %247 = getelementptr inbounds [3 x float], [3 x float]* %246, i64 0, i64 1
  %248 = load float, float* %247, align 4
  %249 = fpext float %248 to double
  %250 = fmul double %245, %249
  %251 = fadd double %242, %250
  %252 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %253 = getelementptr inbounds %struct.vec3, %struct.vec3* %252, i32 0, i32 2
  %254 = load double, double* %253, align 8
  %255 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 0
  %256 = getelementptr inbounds [3 x float], [3 x float]* %255, i64 0, i64 2
  %257 = load float, float* %256, align 8
  %258 = fpext float %257 to double
  %259 = fmul double %254, %258
  %260 = fadd double %251, %259
  %261 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 0), align 8
  %262 = fadd double %260, %261
  %263 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  store double %262, double* %263, align 8
  %264 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %265 = getelementptr inbounds %struct.vec3, %struct.vec3* %264, i32 0, i32 0
  %266 = load double, double* %265, align 8
  %267 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %268 = getelementptr inbounds [3 x float], [3 x float]* %267, i64 0, i64 0
  %269 = load float, float* %268, align 4
  %270 = fpext float %269 to double
  %271 = fmul double %266, %270
  %272 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %273 = getelementptr inbounds %struct.vec3, %struct.vec3* %272, i32 0, i32 1
  %274 = load double, double* %273, align 8
  %275 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %276 = getelementptr inbounds [3 x float], [3 x float]* %275, i64 0, i64 1
  %277 = load float, float* %276, align 4
  %278 = fpext float %277 to double
  %279 = fmul double %274, %278
  %280 = fadd double %271, %279
  %281 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %282 = getelementptr inbounds %struct.vec3, %struct.vec3* %281, i32 0, i32 2
  %283 = load double, double* %282, align 8
  %284 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 1
  %285 = getelementptr inbounds [3 x float], [3 x float]* %284, i64 0, i64 2
  %286 = load float, float* %285, align 4
  %287 = fpext float %286 to double
  %288 = fmul double %283, %287
  %289 = fadd double %280, %288
  %290 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 1), align 8
  %291 = fadd double %289, %290
  %292 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  store double %291, double* %292, align 8
  %293 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %294 = getelementptr inbounds %struct.vec3, %struct.vec3* %293, i32 0, i32 0
  %295 = load double, double* %294, align 8
  %296 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %297 = getelementptr inbounds [3 x float], [3 x float]* %296, i64 0, i64 0
  %298 = load float, float* %297, align 8
  %299 = fpext float %298 to double
  %300 = fmul double %295, %299
  %301 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %302 = getelementptr inbounds %struct.vec3, %struct.vec3* %301, i32 0, i32 1
  %303 = load double, double* %302, align 8
  %304 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %305 = getelementptr inbounds [3 x float], [3 x float]* %304, i64 0, i64 1
  %306 = load float, float* %305, align 4
  %307 = fpext float %306 to double
  %308 = fmul double %303, %307
  %309 = fadd double %300, %308
  %310 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %311 = getelementptr inbounds %struct.vec3, %struct.vec3* %310, i32 0, i32 2
  %312 = load double, double* %311, align 8
  %313 = getelementptr inbounds [3 x [3 x float]], [3 x [3 x float]]* %8, i64 0, i64 2
  %314 = getelementptr inbounds [3 x float], [3 x float]* %313, i64 0, i64 2
  %315 = load float, float* %314, align 8
  %316 = fpext float %315 to double
  %317 = fmul double %312, %316
  %318 = fadd double %309, %317
  %319 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i32 0, i32 0, i32 2), align 8
  %320 = fadd double %318, %319
  %321 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  store double %320, double* %321, align 8
  %322 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 0
  %323 = bitcast %struct.vec3* %322 to i8*
  %324 = bitcast %struct.vec3* %13 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %323, i8* align 8 %324, i64 24, i1 false)
  %325 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 0
  %326 = load double, double* %325, align 8
  %327 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 0
  %328 = load double, double* %327, align 8
  %329 = fadd double %326, %328
  %330 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %331 = getelementptr inbounds %struct.vec3, %struct.vec3* %330, i32 0, i32 0
  store double %329, double* %331, align 8
  %332 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 1
  %333 = load double, double* %332, align 8
  %334 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 1
  %335 = load double, double* %334, align 8
  %336 = fadd double %333, %335
  %337 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %338 = getelementptr inbounds %struct.vec3, %struct.vec3* %337, i32 0, i32 1
  store double %336, double* %338, align 8
  %339 = getelementptr inbounds %struct.vec3, %struct.vec3* %14, i32 0, i32 2
  %340 = load double, double* %339, align 8
  %341 = getelementptr inbounds %struct.vec3, %struct.vec3* %13, i32 0, i32 2
  %342 = load double, double* %341, align 8
  %343 = fadd double %340, %342
  %344 = getelementptr inbounds %struct.ray, %struct.ray* %0, i32 0, i32 1
  %345 = getelementptr inbounds %struct.vec3, %struct.vec3* %344, i32 0, i32 2
  store double %343, double* %345, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ray_sphere(%struct.sphere*, %struct.ray* byval align 8, %struct.spoint*) #0 {
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

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @shade(%struct.vec3* noalias sret, %struct.sphere*, %struct.spoint*, i32) #0 {
  %5 = alloca %struct.sphere*, align 8
  %6 = alloca %struct.spoint*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca %struct.vec3, align 8
  %12 = alloca %struct.ray, align 8
  %13 = alloca %struct.sphere*, align 8
  %14 = alloca i32, align 4
  %15 = alloca double, align 8
  %16 = alloca %struct.ray, align 8
  %17 = alloca %struct.vec3, align 8
  %18 = alloca %struct.vec3, align 8
  store %struct.sphere* %1, %struct.sphere** %5, align 8
  store %struct.spoint* %2, %struct.spoint** %6, align 8
  store i32 %3, i32* %7, align 4
  %19 = bitcast %struct.vec3* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %19, i8 0, i64 24, i1 false)
  store i32 0, i32* %8, align 4
  br label %20

; <label>:20:                                     ; preds = %270, %4
  %21 = load i32, i32* %8, align 4
  %22 = load i32, i32* @lnum, align 4
  %23 = icmp slt i32 %21, %22
  br i1 %23, label %24, label %273

; <label>:24:                                     ; preds = %20
  %25 = load %struct.sphere*, %struct.sphere** @obj_list, align 8
  %26 = getelementptr inbounds %struct.sphere, %struct.sphere* %25, i32 0, i32 3
  %27 = load %struct.sphere*, %struct.sphere** %26, align 8
  store %struct.sphere* %27, %struct.sphere** %13, align 8
  store i32 0, i32* %14, align 4
  %28 = load i32, i32* %8, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %29
  %31 = getelementptr inbounds %struct.vec3, %struct.vec3* %30, i32 0, i32 0
  %32 = load double, double* %31, align 8
  %33 = load %struct.spoint*, %struct.spoint** %6, align 8
  %34 = getelementptr inbounds %struct.spoint, %struct.spoint* %33, i32 0, i32 0
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %34, i32 0, i32 0
  %36 = load double, double* %35, align 8
  %37 = fsub double %32, %36
  %38 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  store double %37, double* %38, align 8
  %39 = load i32, i32* %8, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %40
  %42 = getelementptr inbounds %struct.vec3, %struct.vec3* %41, i32 0, i32 1
  %43 = load double, double* %42, align 8
  %44 = load %struct.spoint*, %struct.spoint** %6, align 8
  %45 = getelementptr inbounds %struct.spoint, %struct.spoint* %44, i32 0, i32 0
  %46 = getelementptr inbounds %struct.vec3, %struct.vec3* %45, i32 0, i32 1
  %47 = load double, double* %46, align 8
  %48 = fsub double %43, %47
  %49 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  store double %48, double* %49, align 8
  %50 = load i32, i32* %8, align 4
  %51 = sext i32 %50 to i64
  %52 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %51
  %53 = getelementptr inbounds %struct.vec3, %struct.vec3* %52, i32 0, i32 2
  %54 = load double, double* %53, align 8
  %55 = load %struct.spoint*, %struct.spoint** %6, align 8
  %56 = getelementptr inbounds %struct.spoint, %struct.spoint* %55, i32 0, i32 0
  %57 = getelementptr inbounds %struct.vec3, %struct.vec3* %56, i32 0, i32 2
  %58 = load double, double* %57, align 8
  %59 = fsub double %54, %58
  %60 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  store double %59, double* %60, align 8
  %61 = getelementptr inbounds %struct.ray, %struct.ray* %12, i32 0, i32 0
  %62 = load %struct.spoint*, %struct.spoint** %6, align 8
  %63 = getelementptr inbounds %struct.spoint, %struct.spoint* %62, i32 0, i32 0
  %64 = bitcast %struct.vec3* %61 to i8*
  %65 = bitcast %struct.vec3* %63 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %64, i8* align 8 %65, i64 24, i1 false)
  %66 = getelementptr inbounds %struct.ray, %struct.ray* %12, i32 0, i32 1
  %67 = bitcast %struct.vec3* %66 to i8*
  %68 = bitcast %struct.vec3* %11 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %67, i8* align 8 %68, i64 24, i1 false)
  br label %69

; <label>:69:                                     ; preds = %77, %24
  %70 = load %struct.sphere*, %struct.sphere** %13, align 8
  %71 = icmp ne %struct.sphere* %70, null
  br i1 %71, label %72, label %81

; <label>:72:                                     ; preds = %69
  %73 = load %struct.sphere*, %struct.sphere** %13, align 8
  %74 = call i32 @ray_sphere(%struct.sphere* %73, %struct.ray* byval align 8 %12, %struct.spoint* null)
  %75 = icmp ne i32 %74, 0
  br i1 %75, label %76, label %77

; <label>:76:                                     ; preds = %72
  store i32 1, i32* %14, align 4
  br label %81

; <label>:77:                                     ; preds = %72
  %78 = load %struct.sphere*, %struct.sphere** %13, align 8
  %79 = getelementptr inbounds %struct.sphere, %struct.sphere* %78, i32 0, i32 3
  %80 = load %struct.sphere*, %struct.sphere** %79, align 8
  store %struct.sphere* %80, %struct.sphere** %13, align 8
  br label %69

; <label>:81:                                     ; preds = %76, %69
  %82 = load i32, i32* %14, align 4
  %83 = icmp ne i32 %82, 0
  br i1 %83, label %269, label %84

; <label>:84:                                     ; preds = %81
  br label %85

; <label>:85:                                     ; preds = %84
  %86 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %87 = load double, double* %86, align 8
  %88 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %89 = load double, double* %88, align 8
  %90 = fmul double %87, %89
  %91 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %92 = load double, double* %91, align 8
  %93 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %94 = load double, double* %93, align 8
  %95 = fmul double %92, %94
  %96 = fadd double %90, %95
  %97 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %98 = load double, double* %97, align 8
  %99 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %100 = load double, double* %99, align 8
  %101 = fmul double %98, %100
  %102 = fadd double %96, %101
  %103 = call double @sqrt(double %102) #5
  store double %103, double* %15, align 8
  %104 = load double, double* %15, align 8
  %105 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %106 = load double, double* %105, align 8
  %107 = fdiv double %106, %104
  store double %107, double* %105, align 8
  %108 = load double, double* %15, align 8
  %109 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %110 = load double, double* %109, align 8
  %111 = fdiv double %110, %108
  store double %111, double* %109, align 8
  %112 = load double, double* %15, align 8
  %113 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %114 = load double, double* %113, align 8
  %115 = fdiv double %114, %112
  store double %115, double* %113, align 8
  br label %116

; <label>:116:                                    ; preds = %85
  %117 = load %struct.spoint*, %struct.spoint** %6, align 8
  %118 = getelementptr inbounds %struct.spoint, %struct.spoint* %117, i32 0, i32 1
  %119 = getelementptr inbounds %struct.vec3, %struct.vec3* %118, i32 0, i32 0
  %120 = load double, double* %119, align 8
  %121 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %122 = load double, double* %121, align 8
  %123 = fmul double %120, %122
  %124 = load %struct.spoint*, %struct.spoint** %6, align 8
  %125 = getelementptr inbounds %struct.spoint, %struct.spoint* %124, i32 0, i32 1
  %126 = getelementptr inbounds %struct.vec3, %struct.vec3* %125, i32 0, i32 1
  %127 = load double, double* %126, align 8
  %128 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %129 = load double, double* %128, align 8
  %130 = fmul double %127, %129
  %131 = fadd double %123, %130
  %132 = load %struct.spoint*, %struct.spoint** %6, align 8
  %133 = getelementptr inbounds %struct.spoint, %struct.spoint* %132, i32 0, i32 1
  %134 = getelementptr inbounds %struct.vec3, %struct.vec3* %133, i32 0, i32 2
  %135 = load double, double* %134, align 8
  %136 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %137 = load double, double* %136, align 8
  %138 = fmul double %135, %137
  %139 = fadd double %131, %138
  %140 = fcmp ogt double %139, 0.000000e+00
  br i1 %140, label %141, label %165

; <label>:141:                                    ; preds = %116
  %142 = load %struct.spoint*, %struct.spoint** %6, align 8
  %143 = getelementptr inbounds %struct.spoint, %struct.spoint* %142, i32 0, i32 1
  %144 = getelementptr inbounds %struct.vec3, %struct.vec3* %143, i32 0, i32 0
  %145 = load double, double* %144, align 8
  %146 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %147 = load double, double* %146, align 8
  %148 = fmul double %145, %147
  %149 = load %struct.spoint*, %struct.spoint** %6, align 8
  %150 = getelementptr inbounds %struct.spoint, %struct.spoint* %149, i32 0, i32 1
  %151 = getelementptr inbounds %struct.vec3, %struct.vec3* %150, i32 0, i32 1
  %152 = load double, double* %151, align 8
  %153 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %154 = load double, double* %153, align 8
  %155 = fmul double %152, %154
  %156 = fadd double %148, %155
  %157 = load %struct.spoint*, %struct.spoint** %6, align 8
  %158 = getelementptr inbounds %struct.spoint, %struct.spoint* %157, i32 0, i32 1
  %159 = getelementptr inbounds %struct.vec3, %struct.vec3* %158, i32 0, i32 2
  %160 = load double, double* %159, align 8
  %161 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %162 = load double, double* %161, align 8
  %163 = fmul double %160, %162
  %164 = fadd double %156, %163
  br label %166

; <label>:165:                                    ; preds = %116
  br label %166

; <label>:166:                                    ; preds = %165, %141
  %167 = phi double [ %164, %141 ], [ 0.000000e+00, %165 ]
  store double %167, double* %10, align 8
  %168 = load %struct.sphere*, %struct.sphere** %5, align 8
  %169 = getelementptr inbounds %struct.sphere, %struct.sphere* %168, i32 0, i32 2
  %170 = getelementptr inbounds %struct.material, %struct.material* %169, i32 0, i32 1
  %171 = load double, double* %170, align 8
  %172 = fcmp ogt double %171, 0.000000e+00
  br i1 %172, label %173, label %230

; <label>:173:                                    ; preds = %166
  %174 = load %struct.spoint*, %struct.spoint** %6, align 8
  %175 = getelementptr inbounds %struct.spoint, %struct.spoint* %174, i32 0, i32 2
  %176 = getelementptr inbounds %struct.vec3, %struct.vec3* %175, i32 0, i32 0
  %177 = load double, double* %176, align 8
  %178 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %179 = load double, double* %178, align 8
  %180 = fmul double %177, %179
  %181 = load %struct.spoint*, %struct.spoint** %6, align 8
  %182 = getelementptr inbounds %struct.spoint, %struct.spoint* %181, i32 0, i32 2
  %183 = getelementptr inbounds %struct.vec3, %struct.vec3* %182, i32 0, i32 1
  %184 = load double, double* %183, align 8
  %185 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %186 = load double, double* %185, align 8
  %187 = fmul double %184, %186
  %188 = fadd double %180, %187
  %189 = load %struct.spoint*, %struct.spoint** %6, align 8
  %190 = getelementptr inbounds %struct.spoint, %struct.spoint* %189, i32 0, i32 2
  %191 = getelementptr inbounds %struct.vec3, %struct.vec3* %190, i32 0, i32 2
  %192 = load double, double* %191, align 8
  %193 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %194 = load double, double* %193, align 8
  %195 = fmul double %192, %194
  %196 = fadd double %188, %195
  %197 = fcmp ogt double %196, 0.000000e+00
  br i1 %197, label %198, label %222

; <label>:198:                                    ; preds = %173
  %199 = load %struct.spoint*, %struct.spoint** %6, align 8
  %200 = getelementptr inbounds %struct.spoint, %struct.spoint* %199, i32 0, i32 2
  %201 = getelementptr inbounds %struct.vec3, %struct.vec3* %200, i32 0, i32 0
  %202 = load double, double* %201, align 8
  %203 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 0
  %204 = load double, double* %203, align 8
  %205 = fmul double %202, %204
  %206 = load %struct.spoint*, %struct.spoint** %6, align 8
  %207 = getelementptr inbounds %struct.spoint, %struct.spoint* %206, i32 0, i32 2
  %208 = getelementptr inbounds %struct.vec3, %struct.vec3* %207, i32 0, i32 1
  %209 = load double, double* %208, align 8
  %210 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 1
  %211 = load double, double* %210, align 8
  %212 = fmul double %209, %211
  %213 = fadd double %205, %212
  %214 = load %struct.spoint*, %struct.spoint** %6, align 8
  %215 = getelementptr inbounds %struct.spoint, %struct.spoint* %214, i32 0, i32 2
  %216 = getelementptr inbounds %struct.vec3, %struct.vec3* %215, i32 0, i32 2
  %217 = load double, double* %216, align 8
  %218 = getelementptr inbounds %struct.vec3, %struct.vec3* %11, i32 0, i32 2
  %219 = load double, double* %218, align 8
  %220 = fmul double %217, %219
  %221 = fadd double %213, %220
  br label %223

; <label>:222:                                    ; preds = %173
  br label %223

; <label>:223:                                    ; preds = %222, %198
  %224 = phi double [ %221, %198 ], [ 0.000000e+00, %222 ]
  %225 = load %struct.sphere*, %struct.sphere** %5, align 8
  %226 = getelementptr inbounds %struct.sphere, %struct.sphere* %225, i32 0, i32 2
  %227 = getelementptr inbounds %struct.material, %struct.material* %226, i32 0, i32 1
  %228 = load double, double* %227, align 8
  %229 = call double @pow(double %224, double %228) #5
  br label %231

; <label>:230:                                    ; preds = %166
  br label %231

; <label>:231:                                    ; preds = %230, %223
  %232 = phi double [ %229, %223 ], [ 0.000000e+00, %230 ]
  store double %232, double* %9, align 8
  %233 = load double, double* %10, align 8
  %234 = load %struct.sphere*, %struct.sphere** %5, align 8
  %235 = getelementptr inbounds %struct.sphere, %struct.sphere* %234, i32 0, i32 2
  %236 = getelementptr inbounds %struct.material, %struct.material* %235, i32 0, i32 0
  %237 = getelementptr inbounds %struct.vec3, %struct.vec3* %236, i32 0, i32 0
  %238 = load double, double* %237, align 8
  %239 = fmul double %233, %238
  %240 = load double, double* %9, align 8
  %241 = fadd double %239, %240
  %242 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  %243 = load double, double* %242, align 8
  %244 = fadd double %243, %241
  store double %244, double* %242, align 8
  %245 = load double, double* %10, align 8
  %246 = load %struct.sphere*, %struct.sphere** %5, align 8
  %247 = getelementptr inbounds %struct.sphere, %struct.sphere* %246, i32 0, i32 2
  %248 = getelementptr inbounds %struct.material, %struct.material* %247, i32 0, i32 0
  %249 = getelementptr inbounds %struct.vec3, %struct.vec3* %248, i32 0, i32 1
  %250 = load double, double* %249, align 8
  %251 = fmul double %245, %250
  %252 = load double, double* %9, align 8
  %253 = fadd double %251, %252
  %254 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  %255 = load double, double* %254, align 8
  %256 = fadd double %255, %253
  store double %256, double* %254, align 8
  %257 = load double, double* %10, align 8
  %258 = load %struct.sphere*, %struct.sphere** %5, align 8
  %259 = getelementptr inbounds %struct.sphere, %struct.sphere* %258, i32 0, i32 2
  %260 = getelementptr inbounds %struct.material, %struct.material* %259, i32 0, i32 0
  %261 = getelementptr inbounds %struct.vec3, %struct.vec3* %260, i32 0, i32 2
  %262 = load double, double* %261, align 8
  %263 = fmul double %257, %262
  %264 = load double, double* %9, align 8
  %265 = fadd double %263, %264
  %266 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  %267 = load double, double* %266, align 8
  %268 = fadd double %267, %265
  store double %268, double* %266, align 8
  br label %269

; <label>:269:                                    ; preds = %231, %81
  br label %270

; <label>:270:                                    ; preds = %269
  %271 = load i32, i32* %8, align 4
  %272 = add nsw i32 %271, 1
  store i32 %272, i32* %8, align 4
  br label %20

; <label>:273:                                    ; preds = %20
  %274 = load %struct.sphere*, %struct.sphere** %5, align 8
  %275 = getelementptr inbounds %struct.sphere, %struct.sphere* %274, i32 0, i32 2
  %276 = getelementptr inbounds %struct.material, %struct.material* %275, i32 0, i32 2
  %277 = load double, double* %276, align 8
  %278 = fcmp ogt double %277, 0.000000e+00
  br i1 %278, label %279, label %336

; <label>:279:                                    ; preds = %273
  %280 = getelementptr inbounds %struct.ray, %struct.ray* %16, i32 0, i32 0
  %281 = load %struct.spoint*, %struct.spoint** %6, align 8
  %282 = getelementptr inbounds %struct.spoint, %struct.spoint* %281, i32 0, i32 0
  %283 = bitcast %struct.vec3* %280 to i8*
  %284 = bitcast %struct.vec3* %282 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %283, i8* align 8 %284, i64 24, i1 false)
  %285 = getelementptr inbounds %struct.ray, %struct.ray* %16, i32 0, i32 1
  %286 = load %struct.spoint*, %struct.spoint** %6, align 8
  %287 = getelementptr inbounds %struct.spoint, %struct.spoint* %286, i32 0, i32 2
  %288 = bitcast %struct.vec3* %285 to i8*
  %289 = bitcast %struct.vec3* %287 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %288, i8* align 8 %289, i64 24, i1 false)
  %290 = getelementptr inbounds %struct.ray, %struct.ray* %16, i32 0, i32 1
  %291 = getelementptr inbounds %struct.vec3, %struct.vec3* %290, i32 0, i32 0
  %292 = load double, double* %291, align 8
  %293 = fmul double %292, 1.000000e+03
  store double %293, double* %291, align 8
  %294 = getelementptr inbounds %struct.ray, %struct.ray* %16, i32 0, i32 1
  %295 = getelementptr inbounds %struct.vec3, %struct.vec3* %294, i32 0, i32 1
  %296 = load double, double* %295, align 8
  %297 = fmul double %296, 1.000000e+03
  store double %297, double* %295, align 8
  %298 = getelementptr inbounds %struct.ray, %struct.ray* %16, i32 0, i32 1
  %299 = getelementptr inbounds %struct.vec3, %struct.vec3* %298, i32 0, i32 2
  %300 = load double, double* %299, align 8
  %301 = fmul double %300, 1.000000e+03
  store double %301, double* %299, align 8
  %302 = load i32, i32* %7, align 4
  %303 = add nsw i32 %302, 1
  call void @trace(%struct.vec3* sret %18, %struct.ray* byval align 8 %16, i32 %303)
  %304 = bitcast %struct.vec3* %17 to i8*
  %305 = bitcast %struct.vec3* %18 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %304, i8* align 8 %305, i64 24, i1 false)
  %306 = getelementptr inbounds %struct.vec3, %struct.vec3* %17, i32 0, i32 0
  %307 = load double, double* %306, align 8
  %308 = load %struct.sphere*, %struct.sphere** %5, align 8
  %309 = getelementptr inbounds %struct.sphere, %struct.sphere* %308, i32 0, i32 2
  %310 = getelementptr inbounds %struct.material, %struct.material* %309, i32 0, i32 2
  %311 = load double, double* %310, align 8
  %312 = fmul double %307, %311
  %313 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  %314 = load double, double* %313, align 8
  %315 = fadd double %314, %312
  store double %315, double* %313, align 8
  %316 = getelementptr inbounds %struct.vec3, %struct.vec3* %17, i32 0, i32 1
  %317 = load double, double* %316, align 8
  %318 = load %struct.sphere*, %struct.sphere** %5, align 8
  %319 = getelementptr inbounds %struct.sphere, %struct.sphere* %318, i32 0, i32 2
  %320 = getelementptr inbounds %struct.material, %struct.material* %319, i32 0, i32 2
  %321 = load double, double* %320, align 8
  %322 = fmul double %317, %321
  %323 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  %324 = load double, double* %323, align 8
  %325 = fadd double %324, %322
  store double %325, double* %323, align 8
  %326 = getelementptr inbounds %struct.vec3, %struct.vec3* %17, i32 0, i32 2
  %327 = load double, double* %326, align 8
  %328 = load %struct.sphere*, %struct.sphere** %5, align 8
  %329 = getelementptr inbounds %struct.sphere, %struct.sphere* %328, i32 0, i32 2
  %330 = getelementptr inbounds %struct.material, %struct.material* %329, i32 0, i32 2
  %331 = load double, double* %330, align 8
  %332 = fmul double %327, %331
  %333 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  %334 = load double, double* %333, align 8
  %335 = fadd double %334, %332
  store double %335, double* %333, align 8
  br label %336

; <label>:336:                                    ; preds = %279, %273
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #3

; Function Attrs: nounwind
declare dso_local double @sqrt(double) #2

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @reflect(%struct.vec3* noalias sret, %struct.vec3* byval align 8, %struct.vec3* byval align 8) #0 {
  %4 = alloca double, align 8
  %5 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %6 = load double, double* %5, align 8
  %7 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %8 = load double, double* %7, align 8
  %9 = fmul double %6, %8
  %10 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %11 = load double, double* %10, align 8
  %12 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %13 = load double, double* %12, align 8
  %14 = fmul double %11, %13
  %15 = fadd double %9, %14
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %17 = load double, double* %16, align 8
  %18 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %19 = load double, double* %18, align 8
  %20 = fmul double %17, %19
  %21 = fadd double %15, %20
  store double %21, double* %4, align 8
  %22 = load double, double* %4, align 8
  %23 = fmul double 2.000000e+00, %22
  %24 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %25 = load double, double* %24, align 8
  %26 = fmul double %23, %25
  %27 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %28 = load double, double* %27, align 8
  %29 = fsub double %26, %28
  %30 = fsub double -0.000000e+00, %29
  %31 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double %30, double* %31, align 8
  %32 = load double, double* %4, align 8
  %33 = fmul double 2.000000e+00, %32
  %34 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %35 = load double, double* %34, align 8
  %36 = fmul double %33, %35
  %37 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %38 = load double, double* %37, align 8
  %39 = fsub double %36, %38
  %40 = fsub double -0.000000e+00, %39
  %41 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double %40, double* %41, align 8
  %42 = load double, double* %4, align 8
  %43 = fmul double 2.000000e+00, %42
  %44 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %45 = load double, double* %44, align 8
  %46 = fmul double %43, %45
  %47 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %48 = load double, double* %47, align 8
  %49 = fsub double %46, %48
  %50 = fsub double -0.000000e+00, %49
  %51 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  store double %50, double* %51, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @cross_product(%struct.vec3* noalias sret, %struct.vec3* byval align 8, %struct.vec3* byval align 8) #0 {
  %4 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %5 = load double, double* %4, align 8
  %6 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %7 = load double, double* %6, align 8
  %8 = fmul double %5, %7
  %9 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %10 = load double, double* %9, align 8
  %11 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %12 = load double, double* %11, align 8
  %13 = fmul double %10, %12
  %14 = fsub double %8, %13
  %15 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double %14, double* %15, align 8
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 2
  %17 = load double, double* %16, align 8
  %18 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %19 = load double, double* %18, align 8
  %20 = fmul double %17, %19
  %21 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %22 = load double, double* %21, align 8
  %23 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 2
  %24 = load double, double* %23, align 8
  %25 = fmul double %22, %24
  %26 = fsub double %20, %25
  %27 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double %26, double* %27, align 8
  %28 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 0
  %29 = load double, double* %28, align 8
  %30 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 1
  %31 = load double, double* %30, align 8
  %32 = fmul double %29, %31
  %33 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i32 0, i32 1
  %34 = load double, double* %33, align 8
  %35 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i32 0, i32 0
  %36 = load double, double* %35, align 8
  %37 = fmul double %34, %36
  %38 = fsub double %32, %37
  %39 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 2
  store double %38, double* %39, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @get_sample_pos(%struct.vec3* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  %10 = alloca %struct.vec3, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  store double 2.000000e+00, double* %8, align 8
  %11 = load i32, i32* @xres, align 4
  %12 = sitofp i32 %11 to double
  %13 = load double, double* @aspect, align 8
  %14 = fdiv double %12, %13
  store double %14, double* %9, align 8
  %15 = load double, double* @get_sample_pos.sf, align 8
  %16 = fcmp oeq double %15, 0.000000e+00
  br i1 %16, label %17, label %21

; <label>:17:                                     ; preds = %4
  %18 = load i32, i32* @xres, align 4
  %19 = sitofp i32 %18 to double
  %20 = fdiv double 2.000000e+00, %19
  store double %20, double* @get_sample_pos.sf, align 8
  br label %21

; <label>:21:                                     ; preds = %17, %4
  %22 = load i32, i32* %5, align 4
  %23 = sitofp i32 %22 to double
  %24 = load i32, i32* @xres, align 4
  %25 = sitofp i32 %24 to double
  %26 = fdiv double %23, %25
  %27 = fsub double %26, 5.000000e-01
  %28 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double %27, double* %28, align 8
  %29 = load i32, i32* %6, align 4
  %30 = sitofp i32 %29 to double
  %31 = load i32, i32* @yres, align 4
  %32 = sitofp i32 %31 to double
  %33 = fdiv double %30, %32
  %34 = fsub double %33, 6.500000e-01
  %35 = fsub double -0.000000e+00, %34
  %36 = load double, double* @aspect, align 8
  %37 = fdiv double %35, %36
  %38 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double %37, double* %38, align 8
  %39 = load i32, i32* %7, align 4
  %40 = icmp ne i32 %39, 0
  br i1 %40, label %41, label %61

; <label>:41:                                     ; preds = %21
  %42 = load i32, i32* %5, align 4
  %43 = load i32, i32* %6, align 4
  %44 = load i32, i32* %7, align 4
  call void @jitter(%struct.vec3* sret %10, i32 %42, i32 %43, i32 %44)
  %45 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 0
  %46 = load double, double* %45, align 8
  %47 = load double, double* @get_sample_pos.sf, align 8
  %48 = fmul double %46, %47
  %49 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  %50 = load double, double* %49, align 8
  %51 = fadd double %50, %48
  store double %51, double* %49, align 8
  %52 = getelementptr inbounds %struct.vec3, %struct.vec3* %10, i32 0, i32 1
  %53 = load double, double* %52, align 8
  %54 = load double, double* @get_sample_pos.sf, align 8
  %55 = fmul double %53, %54
  %56 = load double, double* @aspect, align 8
  %57 = fdiv double %55, %56
  %58 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  %59 = load double, double* %58, align 8
  %60 = fadd double %59, %57
  store double %60, double* %58, align 8
  br label %61

; <label>:61:                                     ; preds = %41, %21
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @jitter(%struct.vec3* noalias sret, i32, i32, i32) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  %8 = load i32, i32* %5, align 4
  %9 = load i32, i32* %6, align 4
  %10 = shl i32 %9, 2
  %11 = add nsw i32 %8, %10
  %12 = load i32, i32* %5, align 4
  %13 = load i32, i32* %7, align 4
  %14 = add nsw i32 %12, %13
  %15 = and i32 %14, 1023
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %16
  %18 = load i32, i32* %17, align 4
  %19 = add nsw i32 %11, %18
  %20 = and i32 %19, 1023
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %21
  %23 = getelementptr inbounds %struct.vec3, %struct.vec3* %22, i32 0, i32 0
  %24 = load double, double* %23, align 8
  %25 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 0
  store double %24, double* %25, align 8
  %26 = load i32, i32* %6, align 4
  %27 = load i32, i32* %5, align 4
  %28 = shl i32 %27, 2
  %29 = add nsw i32 %26, %28
  %30 = load i32, i32* %6, align 4
  %31 = load i32, i32* %7, align 4
  %32 = add nsw i32 %30, %31
  %33 = and i32 %32, 1023
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %34
  %36 = load i32, i32* %35, align 4
  %37 = add nsw i32 %29, %36
  %38 = and i32 %37, 1023
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %39
  %41 = getelementptr inbounds %struct.vec3, %struct.vec3* %40, i32 0, i32 1
  %42 = load double, double* %41, align 8
  %43 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i32 0, i32 1
  store double %42, double* %43, align 8
  ret void
}

declare dso_local i8* @fgets(i8*, i32, %struct._IO_FILE*) #1

; Function Attrs: nounwind
declare dso_local i8* @strtok(i8*, i8*) #2

; Function Attrs: nounwind readonly
declare dso_local double @atof(i8*) #4

; Function Attrs: nounwind
declare dso_local i32 @gettimeofday(%struct.timeval*, %struct.timezone*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { nounwind readonly }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 7.0.0-3~ubuntu0.18.04.1 (tags/RELEASE_700/final)"}
