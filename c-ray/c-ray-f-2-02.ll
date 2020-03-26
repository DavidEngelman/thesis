; ModuleID = 'c-ray-f-2-02.c'
source_filename = "c-ray-f-2-02.c"
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
%struct.spoint = type { %struct.vec3, %struct.vec3, %struct.vec3, double }
%struct.ray = type { %struct.vec3, %struct.vec3 }

@xres = dso_local local_unnamed_addr global i32 800, align 4
@yres = dso_local local_unnamed_addr global i32 600, align 4
@aspect = dso_local local_unnamed_addr global double 0x3FF55554FBDAD752, align 8
@lnum = dso_local local_unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [363 x i8] c"Usage: c-ray-f [options]\0A  Reads a scene file from stdin, writes the image to stdout, and stats to stderr.\0A\0AOptions:\0A  -s WxH     where W is the width and H the height of the image\0A  -r <rays>  shoot <rays> rays per pixel (antialiasing)\0A  -i <file>  read from <file> instead of stdin\0A  -o <file>  write to <file> instead of stdout\0A  -h         this help screen\0A\0A\00", align 1
@usage = dso_local local_unnamed_addr global i8* getelementptr inbounds ([363 x i8], [363 x i8]* @.str, i64 0, i64 0), align 8
@stdin = external dso_local local_unnamed_addr global %struct._IO_FILE*, align 8
@stdout = external dso_local local_unnamed_addr global %struct._IO_FILE*, align 8
@.str.1 = private unnamed_addr constant [6 x i8] c"scene\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"rendered_scene\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.5 = private unnamed_addr constant [31 x i8] c"pixel buffer allocation failed\00", align 1
@urand = common dso_local local_unnamed_addr global [1024 x %struct.vec3] zeroinitializer, align 16
@irand = common dso_local local_unnamed_addr global [1024 x i32] zeroinitializer, align 16
@stderr = external dso_local local_unnamed_addr global %struct._IO_FILE*, align 8
@.str.6 = private unnamed_addr constant [48 x i8] c"Rendering took: %lu seconds (%lu milliseconds)\0A\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"P6\0A%d %d\0A255\0A\00", align 1
@obj_list = common dso_local local_unnamed_addr global %struct.sphere* null, align 8
@lights = common dso_local local_unnamed_addr global [16 x %struct.vec3] zeroinitializer, align 16
@cam = common dso_local local_unnamed_addr global %struct.camera zeroinitializer, align 8
@get_sample_pos.sf = internal unnamed_addr global double 0.000000e+00, align 8
@.str.8 = private unnamed_addr constant [4 x i8] c" \09\0A\00", align 1
@.str.9 = private unnamed_addr constant [18 x i8] c"unknown type: %c\0A\00", align 1
@get_msec.timeval = internal global %struct.timeval zeroinitializer, align 8
@get_msec.first_timeval = internal unnamed_addr global %struct.timeval zeroinitializer, align 8

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = tail call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0))
  %2 = tail call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0))
  %3 = load i32, i32* @xres, align 4, !tbaa !2
  %4 = load i32, i32* @yres, align 4, !tbaa !2
  %5 = mul nsw i32 %4, %3
  %6 = sext i32 %5 to i64
  %7 = shl nsw i64 %6, 2
  %8 = tail call noalias i8* @malloc(i64 %7) #6
  %9 = bitcast i8* %8 to i32*
  %10 = icmp eq i8* %8, null
  br i1 %10, label %11, label %12

11:                                               ; preds = %0
  tail call void @perror(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.5, i64 0, i64 0)) #7
  br label %114

12:                                               ; preds = %0
  tail call void @load_scene(%struct._IO_FILE* %1)
  br label %13

13:                                               ; preds = %13, %12
  %14 = phi i64 [ 0, %12 ], [ %20, %13 ]
  %15 = tail call i32 @rand() #6
  %16 = sitofp i32 %15 to double
  %17 = fdiv double %16, 0x41DFFFFFFFC00000
  %18 = fadd double %17, -5.000000e-01
  %19 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %14, i32 0
  store double %18, double* %19, align 8, !tbaa !6
  %20 = add nuw nsw i64 %14, 1
  %21 = icmp eq i64 %20, 1024
  br i1 %21, label %22, label %13

22:                                               ; preds = %13, %22
  %23 = phi i64 [ %29, %22 ], [ 0, %13 ]
  %24 = tail call i32 @rand() #6
  %25 = sitofp i32 %24 to double
  %26 = fdiv double %25, 0x41DFFFFFFFC00000
  %27 = fadd double %26, -5.000000e-01
  %28 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %23, i32 1
  store double %27, double* %28, align 8, !tbaa !9
  %29 = add nuw nsw i64 %23, 1
  %30 = icmp eq i64 %29, 1024
  br i1 %30, label %31, label %22

31:                                               ; preds = %22, %31
  %32 = phi i64 [ %39, %31 ], [ 0, %22 ]
  %33 = tail call i32 @rand() #6
  %34 = sitofp i32 %33 to double
  %35 = fdiv double %34, 0x41DFFFFFFFC00000
  %36 = fmul double %35, 1.024000e+03
  %37 = fptosi double %36 to i32
  %38 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %32
  store i32 %37, i32* %38, align 4, !tbaa !2
  %39 = add nuw nsw i64 %32, 1
  %40 = icmp eq i64 %39, 1024
  br i1 %40, label %41, label %31

41:                                               ; preds = %31
  %42 = tail call i32 @gettimeofday(%struct.timeval* nonnull @get_msec.timeval, %struct.timezone* null) #6
  %43 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 0), align 8, !tbaa !10
  %44 = icmp eq i64 %43, 0
  br i1 %44, label %45, label %46

45:                                               ; preds = %41
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.timeval* @get_msec.first_timeval to i8*), i8* align 8 bitcast (%struct.timeval* @get_msec.timeval to i8*), i64 16, i1 false) #6, !tbaa.struct !13
  br label %55

46:                                               ; preds = %41
  %47 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 0), align 8, !tbaa !10
  %48 = sub nsw i64 %47, %43
  %49 = mul nsw i64 %48, 1000
  %50 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 1), align 8, !tbaa !15
  %51 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 1), align 8, !tbaa !15
  %52 = sub nsw i64 %50, %51
  %53 = sdiv i64 %52, 1000
  %54 = add nsw i64 %53, %49
  br label %55

55:                                               ; preds = %45, %46
  %56 = phi i64 [ 0, %45 ], [ %54, %46 ]
  %57 = load i32, i32* @xres, align 4, !tbaa !2
  %58 = load i32, i32* @yres, align 4, !tbaa !2
  tail call void @render(i32 %57, i32 %58, i32* nonnull %9, i32 1)
  %59 = tail call i32 @gettimeofday(%struct.timeval* nonnull @get_msec.timeval, %struct.timezone* null) #6
  %60 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 0), align 8, !tbaa !10
  %61 = icmp eq i64 %60, 0
  br i1 %61, label %62, label %63

62:                                               ; preds = %55
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.timeval* @get_msec.first_timeval to i8*), i8* align 8 bitcast (%struct.timeval* @get_msec.timeval to i8*), i64 16, i1 false) #6, !tbaa.struct !13
  br label %72

63:                                               ; preds = %55
  %64 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 0), align 8, !tbaa !10
  %65 = sub nsw i64 %64, %60
  %66 = mul nsw i64 %65, 1000
  %67 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 1), align 8, !tbaa !15
  %68 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 1), align 8, !tbaa !15
  %69 = sub nsw i64 %67, %68
  %70 = sdiv i64 %69, 1000
  %71 = add nsw i64 %70, %66
  br label %72

72:                                               ; preds = %62, %63
  %73 = phi i64 [ 0, %62 ], [ %71, %63 ]
  %74 = sub i64 %73, %56
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !16
  %76 = udiv i64 %74, 1000
  %77 = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.6, i64 0, i64 0), i64 %76, i64 %74) #7
  %78 = load i32, i32* @xres, align 4, !tbaa !2
  %79 = load i32, i32* @yres, align 4, !tbaa !2
  %80 = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.7, i64 0, i64 0), i32 %78, i32 %79)
  %81 = load i32, i32* @xres, align 4, !tbaa !2
  %82 = load i32, i32* @yres, align 4, !tbaa !2
  %83 = mul nsw i32 %82, %81
  %84 = icmp sgt i32 %83, 0
  br i1 %84, label %85, label %103

85:                                               ; preds = %72, %85
  %86 = phi i64 [ %97, %85 ], [ 0, %72 ]
  %87 = getelementptr inbounds i32, i32* %9, i64 %86
  %88 = load i32, i32* %87, align 4, !tbaa !2
  %89 = lshr i32 %88, 16
  %90 = and i32 %89, 255
  %91 = tail call i32 @fputc_unlocked(i32 %90, %struct._IO_FILE* %2)
  %92 = lshr i32 %88, 8
  %93 = and i32 %92, 255
  %94 = tail call i32 @fputc_unlocked(i32 %93, %struct._IO_FILE* %2)
  %95 = and i32 %88, 255
  %96 = tail call i32 @fputc_unlocked(i32 %95, %struct._IO_FILE* %2)
  %97 = add nuw nsw i64 %86, 1
  %98 = load i32, i32* @xres, align 4, !tbaa !2
  %99 = load i32, i32* @yres, align 4, !tbaa !2
  %100 = mul nsw i32 %99, %98
  %101 = sext i32 %100 to i64
  %102 = icmp slt i64 %97, %101
  br i1 %102, label %85, label %103

103:                                              ; preds = %85, %72
  %104 = tail call i32 @fflush(%struct._IO_FILE* %2)
  %105 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8, !tbaa !16
  %106 = icmp eq %struct._IO_FILE* %1, %105
  br i1 %106, label %109, label %107

107:                                              ; preds = %103
  %108 = tail call i32 @fclose(%struct._IO_FILE* %1)
  br label %109

109:                                              ; preds = %103, %107
  %110 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !tbaa !16
  %111 = icmp eq %struct._IO_FILE* %2, %110
  br i1 %111, label %114, label %112

112:                                              ; preds = %109
  %113 = tail call i32 @fclose(%struct._IO_FILE* %2)
  br label %114

114:                                              ; preds = %112, %109, %11
  %115 = phi i32 [ 1, %11 ], [ 0, %109 ], [ 0, %112 ]
  ret i32 %115
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare dso_local noalias %struct._IO_FILE* @fopen(i8* nocapture readonly, i8* nocapture readonly) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local noalias i8* @malloc(i64) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local void @perror(i8* nocapture readonly) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define dso_local void @load_scene(%struct._IO_FILE* nocapture) local_unnamed_addr #0 {
  %2 = alloca [256 x i8], align 16
  %3 = alloca %struct.vec3, align 8
  %4 = alloca %struct.vec3, align 8
  %5 = getelementptr inbounds [256 x i8], [256 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %5) #6
  %6 = tail call noalias i8* @malloc(i64 80) #6
  store i8* %6, i8** bitcast (%struct.sphere** @obj_list to i8**), align 8, !tbaa !16
  %7 = getelementptr inbounds i8, i8* %6, i64 72
  %8 = bitcast i8* %7 to %struct.sphere**
  store %struct.sphere* null, %struct.sphere** %8, align 8, !tbaa !18
  %9 = call i8* @fgets(i8* nonnull %5, i32 256, %struct._IO_FILE* %0)
  %10 = icmp eq i8* %9, null
  br i1 %10, label %93, label %11

11:                                               ; preds = %1
  %12 = bitcast %struct.vec3* %3 to i8*
  %13 = bitcast %struct.vec3* %4 to i8*
  %14 = getelementptr inbounds %struct.vec3, %struct.vec3* %3, i64 0, i32 0
  %15 = getelementptr inbounds %struct.vec3, %struct.vec3* %4, i64 0, i32 0
  %16 = getelementptr inbounds double, double* %14, i64 1
  %17 = getelementptr inbounds double, double* %14, i64 2
  %18 = getelementptr inbounds double, double* %15, i64 1
  %19 = getelementptr inbounds double, double* %15, i64 2
  br label %20

20:                                               ; preds = %11, %90
  %21 = phi i8* [ %9, %11 ], [ %91, %90 ]
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %12) #6
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %13) #6
  br label %22

22:                                               ; preds = %25, %20
  %23 = phi i8* [ %21, %20 ], [ %26, %25 ]
  %24 = load i8, i8* %23, align 1, !tbaa !21
  switch i8 %24, label %27 [
    i8 32, label %25
    i8 9, label %25
    i8 35, label %90
    i8 10, label %90
  ]

25:                                               ; preds = %22, %22
  %26 = getelementptr inbounds i8, i8* %23, i64 1
  br label %22

27:                                               ; preds = %22
  %28 = call i8* @strtok(i8* nonnull %5, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %29 = icmp eq i8* %28, null
  br i1 %29, label %90, label %30

30:                                               ; preds = %27
  %31 = load i8, i8* %28, align 1, !tbaa !21
  %32 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %33 = icmp eq i8* %32, null
  br i1 %33, label %38, label %34

34:                                               ; preds = %30
  %35 = call double @strtod(i8* nocapture nonnull %32, i8** null) #6
  store double %35, double* %14, align 8, !tbaa !22
  %36 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %37 = icmp eq i8* %36, null
  br i1 %37, label %38, label %94

38:                                               ; preds = %98, %94, %34, %30
  %39 = sext i8 %31 to i32
  %40 = icmp eq i8 %31, 108
  br i1 %40, label %41, label %47

41:                                               ; preds = %38
  %42 = load i32, i32* @lnum, align 4, !tbaa !2
  %43 = add nsw i32 %42, 1
  store i32 %43, i32* @lnum, align 4, !tbaa !2
  %44 = sext i32 %42 to i64
  %45 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %44
  %46 = bitcast %struct.vec3* %45 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %46, i8* nonnull align 8 %12, i64 24, i1 false), !tbaa.struct !23
  br label %90

47:                                               ; preds = %38
  %48 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %49 = icmp eq i8* %48, null
  br i1 %49, label %90, label %50

50:                                               ; preds = %47
  %51 = call double @strtod(i8* nocapture nonnull %48, i8** null) #6
  %52 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %53 = icmp eq i8* %52, null
  br i1 %53, label %58, label %54

54:                                               ; preds = %50
  %55 = call double @strtod(i8* nocapture nonnull %52, i8** null) #6
  store double %55, double* %15, align 8, !tbaa !22
  %56 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %57 = icmp eq i8* %56, null
  br i1 %57, label %58, label %100

58:                                               ; preds = %104, %100, %54, %50
  %59 = icmp eq i8 %31, 99
  br i1 %59, label %60, label %61

60:                                               ; preds = %58
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.camera* @cam to i8*), i8* nonnull align 8 %12, i64 24, i1 false), !tbaa.struct !23
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.vec3* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 1) to i8*), i8* nonnull align 8 %13, i64 24, i1 false), !tbaa.struct !23
  store double %51, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 2), align 8, !tbaa !24
  br label %90

61:                                               ; preds = %58
  %62 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %63 = icmp eq i8* %62, null
  br i1 %63, label %90, label %64

64:                                               ; preds = %61
  %65 = call double @strtod(i8* nocapture nonnull %62, i8** null) #6
  %66 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %67 = icmp eq i8* %66, null
  br i1 %67, label %90, label %68

68:                                               ; preds = %64
  %69 = icmp eq i8 %31, 115
  br i1 %69, label %70, label %87

70:                                               ; preds = %68
  %71 = call double @strtod(i8* nocapture nonnull %66, i8** null) #6
  %72 = call noalias i8* @malloc(i64 80) #6
  %73 = load %struct.sphere*, %struct.sphere** @obj_list, align 8, !tbaa !16
  %74 = getelementptr inbounds %struct.sphere, %struct.sphere* %73, i64 0, i32 3
  %75 = bitcast %struct.sphere** %74 to i64*
  %76 = load i64, i64* %75, align 8, !tbaa !18
  %77 = getelementptr inbounds i8, i8* %72, i64 72
  %78 = bitcast i8* %77 to i64*
  store i64 %76, i64* %78, align 8, !tbaa !18
  %79 = bitcast %struct.sphere** %74 to i8**
  store i8* %72, i8** %79, align 8, !tbaa !18
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %72, i8* nonnull align 8 %12, i64 24, i1 false), !tbaa.struct !23
  %80 = getelementptr inbounds i8, i8* %72, i64 24
  %81 = bitcast i8* %80 to double*
  store double %51, double* %81, align 8, !tbaa !26
  %82 = getelementptr inbounds i8, i8* %72, i64 32
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %82, i8* nonnull align 8 %13, i64 24, i1 false), !tbaa.struct !23
  %83 = getelementptr inbounds i8, i8* %72, i64 56
  %84 = bitcast i8* %83 to double*
  store double %65, double* %84, align 8, !tbaa !27
  %85 = getelementptr inbounds i8, i8* %72, i64 64
  %86 = bitcast i8* %85 to double*
  store double %71, double* %86, align 8, !tbaa !28
  br label %90

87:                                               ; preds = %68
  %88 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !16
  %89 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %88, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.9, i64 0, i64 0), i32 %39) #7
  br label %90

90:                                               ; preds = %22, %22, %70, %87, %64, %61, %47, %27, %60, %41
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %13) #6
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %12) #6
  %91 = call i8* @fgets(i8* nonnull %5, i32 256, %struct._IO_FILE* %0)
  %92 = icmp eq i8* %91, null
  br i1 %92, label %93, label %20

93:                                               ; preds = %90, %1
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %5) #6
  ret void

94:                                               ; preds = %34
  %95 = call double @strtod(i8* nocapture nonnull %36, i8** null) #6
  store double %95, double* %16, align 8, !tbaa !22
  %96 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %97 = icmp eq i8* %96, null
  br i1 %97, label %38, label %98

98:                                               ; preds = %94
  %99 = call double @strtod(i8* nocapture nonnull %96, i8** null) #6
  store double %99, double* %17, align 8, !tbaa !22
  br label %38

100:                                              ; preds = %54
  %101 = call double @strtod(i8* nocapture nonnull %56, i8** null) #6
  store double %101, double* %18, align 8, !tbaa !22
  %102 = call i8* @strtok(i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i64 0, i64 0)) #6
  %103 = icmp eq i8* %102, null
  br i1 %103, label %58, label %104

104:                                              ; preds = %100
  %105 = call double @strtod(i8* nocapture nonnull %102, i8** null) #6
  store double %105, double* %19, align 8, !tbaa !22
  br label %58
}

; Function Attrs: nounwind
declare dso_local i32 @rand() local_unnamed_addr #3

; Function Attrs: nounwind uwtable
define dso_local i64 @get_msec() local_unnamed_addr #0 {
  %1 = tail call i32 @gettimeofday(%struct.timeval* nonnull @get_msec.timeval, %struct.timezone* null) #6
  %2 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 0), align 8, !tbaa !10
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %4, label %5

4:                                                ; preds = %0
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 bitcast (%struct.timeval* @get_msec.first_timeval to i8*), i8* align 8 bitcast (%struct.timeval* @get_msec.timeval to i8*), i64 16, i1 false), !tbaa.struct !13
  br label %14

5:                                                ; preds = %0
  %6 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 0), align 8, !tbaa !10
  %7 = sub nsw i64 %6, %2
  %8 = mul nsw i64 %7, 1000
  %9 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.timeval, i64 0, i32 1), align 8, !tbaa !15
  %10 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @get_msec.first_timeval, i64 0, i32 1), align 8, !tbaa !15
  %11 = sub nsw i64 %9, %10
  %12 = sdiv i64 %11, 1000
  %13 = add nsw i64 %12, %8
  br label %14

14:                                               ; preds = %5, %4
  %15 = phi i64 [ 0, %4 ], [ %13, %5 ]
  ret i64 %15
}

; Function Attrs: nounwind uwtable
define dso_local void @render(i32, i32, i32* nocapture, i32) local_unnamed_addr #0 {
  %5 = alloca %struct.spoint, align 8
  %6 = alloca %struct.spoint, align 8
  %7 = alloca %struct.ray, align 8
  %8 = alloca %struct.vec3, align 16
  %9 = alloca %struct.ray, align 8
  %10 = sitofp i32 %3 to double
  %11 = fdiv double 1.000000e+00, %10
  %12 = icmp sgt i32 %1, 0
  br i1 %12, label %13, label %103

13:                                               ; preds = %4
  %14 = icmp sgt i32 %0, 0
  %15 = icmp sgt i32 %3, 0
  %16 = bitcast %struct.vec3* %8 to i8*
  %17 = bitcast %struct.ray* %7 to i8*
  %18 = bitcast %struct.ray* %9 to i8*
  %19 = bitcast %struct.spoint* %5 to i8*
  %20 = bitcast %struct.spoint* %6 to i8*
  %21 = getelementptr inbounds %struct.spoint, %struct.spoint* %5, i64 0, i32 3
  %22 = getelementptr inbounds %struct.spoint, %struct.spoint* %6, i64 0, i32 3
  %23 = getelementptr inbounds %struct.vec3, %struct.vec3* %8, i64 0, i32 2
  %24 = bitcast %struct.vec3* %8 to <2 x double>*
  br label %25

25:                                               ; preds = %99, %13
  %26 = phi i32* [ %2, %13 ], [ %100, %99 ]
  %27 = phi i32 [ 0, %13 ], [ %101, %99 ]
  br i1 %14, label %28, label %99

28:                                               ; preds = %25, %69
  %29 = phi i32* [ %96, %69 ], [ %26, %25 ]
  %30 = phi i32 [ %97, %69 ], [ 0, %25 ]
  br i1 %15, label %31, label %69

31:                                               ; preds = %28, %62
  %32 = phi double [ %66, %62 ], [ 0.000000e+00, %28 ]
  %33 = phi i32 [ %67, %62 ], [ 0, %28 ]
  %34 = phi <2 x double> [ %65, %62 ], [ zeroinitializer, %28 ]
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %16) #6
  call void @get_primary_ray(%struct.ray* nonnull sret %9, i32 %30, i32 %27, i32 %33)
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %17)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %17, i8* nonnull align 8 %18, i64 48, i1 false) #6
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %19) #6, !noalias !29
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %20) #6, !noalias !29
  %35 = load %struct.sphere*, %struct.sphere** @obj_list, align 8, !tbaa !16, !noalias !29
  %36 = getelementptr inbounds %struct.sphere, %struct.sphere* %35, i64 0, i32 3
  %37 = load %struct.sphere*, %struct.sphere** %36, align 8, !tbaa !18, !noalias !29
  %38 = icmp eq %struct.sphere* %37, null
  br i1 %38, label %61, label %39

39:                                               ; preds = %31, %51
  %40 = phi %struct.sphere* [ %54, %51 ], [ %37, %31 ]
  %41 = phi %struct.sphere* [ %52, %51 ], [ null, %31 ]
  %42 = call i32 @ray_sphere(%struct.sphere* nonnull %40, %struct.ray* nonnull byval(%struct.ray) align 8 %7, %struct.spoint* nonnull %5) #6, !noalias !29
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %51, label %44

44:                                               ; preds = %39
  %45 = icmp eq %struct.sphere* %41, null
  br i1 %45, label %50, label %46

46:                                               ; preds = %44
  %47 = load double, double* %21, align 8, !tbaa !32, !noalias !29
  %48 = load double, double* %22, align 8, !tbaa !32, !noalias !29
  %49 = fcmp olt double %47, %48
  br i1 %49, label %50, label %51

50:                                               ; preds = %46, %44
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %20, i8* nonnull align 8 %19, i64 80, i1 false) #6, !tbaa.struct !34, !noalias !29
  br label %51

51:                                               ; preds = %50, %46, %39
  %52 = phi %struct.sphere* [ %40, %50 ], [ %41, %46 ], [ %41, %39 ]
  %53 = getelementptr inbounds %struct.sphere, %struct.sphere* %40, i64 0, i32 3
  %54 = load %struct.sphere*, %struct.sphere** %53, align 8, !tbaa !18, !noalias !29
  %55 = icmp eq %struct.sphere* %54, null
  br i1 %55, label %56, label %39

56:                                               ; preds = %51
  %57 = icmp eq %struct.sphere* %52, null
  br i1 %57, label %61, label %58

58:                                               ; preds = %56
  call void @shade(%struct.vec3* nonnull sret %8, %struct.sphere* nonnull %52, %struct.spoint* nonnull %6, i32 0) #6
  %59 = load <2 x double>, <2 x double>* %24, align 16, !tbaa !22
  %60 = load double, double* %23, align 16, !tbaa !35
  br label %62

61:                                               ; preds = %56, %31
  call void @llvm.memset.p0i8.i64(i8* nonnull align 16 %16, i8 0, i64 24, i1 false) #6, !alias.scope !29
  br label %62

62:                                               ; preds = %58, %61
  %63 = phi double [ %60, %58 ], [ 0.000000e+00, %61 ]
  %64 = phi <2 x double> [ %59, %58 ], [ zeroinitializer, %61 ]
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %20) #6, !noalias !29
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %19) #6, !noalias !29
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %17)
  %65 = fadd <2 x double> %34, %64
  %66 = fadd double %32, %63
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %16) #6
  %67 = add nuw nsw i32 %33, 1
  %68 = icmp eq i32 %67, %3
  br i1 %68, label %69, label %31

69:                                               ; preds = %62, %28
  %70 = phi double [ 0.000000e+00, %28 ], [ %66, %62 ]
  %71 = phi <2 x double> [ zeroinitializer, %28 ], [ %65, %62 ]
  %72 = extractelement <2 x double> %71, i32 0
  %73 = fmul double %11, %72
  %74 = extractelement <2 x double> %71, i32 1
  %75 = fmul double %11, %74
  %76 = fmul double %11, %70
  %77 = fcmp olt double %73, 1.000000e+00
  %78 = select i1 %77, double %73, double 1.000000e+00
  %79 = fmul double %78, 2.550000e+02
  %80 = fptoui double %79 to i32
  %81 = shl i32 %80, 16
  %82 = and i32 %81, 16711680
  %83 = fcmp olt double %75, 1.000000e+00
  %84 = select i1 %83, double %75, double 1.000000e+00
  %85 = fmul double %84, 2.550000e+02
  %86 = fptoui double %85 to i32
  %87 = shl i32 %86, 8
  %88 = and i32 %87, 65280
  %89 = or i32 %88, %82
  %90 = fcmp olt double %76, 1.000000e+00
  %91 = select i1 %90, double %76, double 1.000000e+00
  %92 = fmul double %91, 2.550000e+02
  %93 = fptoui double %92 to i32
  %94 = and i32 %93, 255
  %95 = or i32 %89, %94
  %96 = getelementptr inbounds i32, i32* %29, i64 1
  store i32 %95, i32* %29, align 4, !tbaa !2
  %97 = add nuw nsw i32 %30, 1
  %98 = icmp eq i32 %97, %0
  br i1 %98, label %99, label %28

99:                                               ; preds = %69, %25
  %100 = phi i32* [ %26, %25 ], [ %96, %69 ]
  %101 = add nuw nsw i32 %27, 1
  %102 = icmp eq i32 %101, %1
  br i1 %102, label %103, label %25

103:                                              ; preds = %99, %4
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local i32 @fflush(%struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local i32 @fclose(%struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @trace(%struct.vec3* noalias nocapture sret, %struct.ray* nocapture readonly byval(%struct.ray) align 8, i32) local_unnamed_addr #0 {
  %4 = alloca %struct.spoint, align 8
  %5 = alloca %struct.spoint, align 8
  %6 = bitcast %struct.spoint* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %6) #6
  %7 = bitcast %struct.spoint* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %7) #6
  %8 = icmp sgt i32 %2, 4
  br i1 %8, label %17, label %9

9:                                                ; preds = %3
  %10 = load %struct.sphere*, %struct.sphere** @obj_list, align 8, !tbaa !16
  %11 = getelementptr inbounds %struct.sphere, %struct.sphere* %10, i64 0, i32 3
  %12 = load %struct.sphere*, %struct.sphere** %11, align 8, !tbaa !18
  %13 = icmp eq %struct.sphere* %12, null
  br i1 %13, label %39, label %14

14:                                               ; preds = %9
  %15 = getelementptr inbounds %struct.spoint, %struct.spoint* %4, i64 0, i32 3
  %16 = getelementptr inbounds %struct.spoint, %struct.spoint* %5, i64 0, i32 3
  br label %19

17:                                               ; preds = %3
  %18 = bitcast %struct.vec3* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %18, i8 0, i64 24, i1 false)
  br label %41

19:                                               ; preds = %14, %31
  %20 = phi %struct.sphere* [ %12, %14 ], [ %34, %31 ]
  %21 = phi %struct.sphere* [ null, %14 ], [ %32, %31 ]
  %22 = call i32 @ray_sphere(%struct.sphere* nonnull %20, %struct.ray* nonnull byval(%struct.ray) align 8 %1, %struct.spoint* nonnull %4)
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %31, label %24

24:                                               ; preds = %19
  %25 = icmp eq %struct.sphere* %21, null
  br i1 %25, label %30, label %26

26:                                               ; preds = %24
  %27 = load double, double* %15, align 8, !tbaa !32
  %28 = load double, double* %16, align 8, !tbaa !32
  %29 = fcmp olt double %27, %28
  br i1 %29, label %30, label %31

30:                                               ; preds = %24, %26
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %7, i8* nonnull align 8 %6, i64 80, i1 false), !tbaa.struct !34
  br label %31

31:                                               ; preds = %19, %26, %30
  %32 = phi %struct.sphere* [ %20, %30 ], [ %21, %26 ], [ %21, %19 ]
  %33 = getelementptr inbounds %struct.sphere, %struct.sphere* %20, i64 0, i32 3
  %34 = load %struct.sphere*, %struct.sphere** %33, align 8, !tbaa !18
  %35 = icmp eq %struct.sphere* %34, null
  br i1 %35, label %36, label %19

36:                                               ; preds = %31
  %37 = icmp eq %struct.sphere* %32, null
  br i1 %37, label %39, label %38

38:                                               ; preds = %36
  call void @shade(%struct.vec3* nonnull sret %0, %struct.sphere* nonnull %32, %struct.spoint* nonnull %5, i32 %2)
  br label %41

39:                                               ; preds = %9, %36
  %40 = bitcast %struct.vec3* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %40, i8 0, i64 24, i1 false)
  br label %41

41:                                               ; preds = %38, %39, %17
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %7) #6
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %6) #6
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @get_primary_ray(%struct.ray* noalias nocapture sret, i32, i32, i32) local_unnamed_addr #0 {
  %5 = load <2 x double>, <2 x double>* bitcast (double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 1, i32 0) to <2 x double>*), align 8, !tbaa !22
  %6 = load <2 x double>, <2 x double>* bitcast (%struct.camera* @cam to <2 x double>*), align 8, !tbaa !22
  %7 = fsub <2 x double> %5, %6
  %8 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 1, i32 2), align 8, !tbaa !36
  %9 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 0, i32 2), align 8, !tbaa !37
  %10 = fsub double %8, %9
  %11 = extractelement <2 x double> %7, i32 0
  %12 = fmul double %11, %11
  %13 = extractelement <2 x double> %7, i32 1
  %14 = fmul double %13, %13
  %15 = fadd double %12, %14
  %16 = fmul double %10, %10
  %17 = fadd double %15, %16
  %18 = tail call double @sqrt(double %17) #6
  %19 = insertelement <2 x double> undef, double %18, i32 0
  %20 = shufflevector <2 x double> %19, <2 x double> undef, <2 x i32> zeroinitializer
  %21 = fdiv <2 x double> %7, %20
  %22 = insertelement <2 x double> undef, double %10, i32 0
  %23 = extractelement <2 x double> %21, i32 0
  %24 = shufflevector <2 x double> %22, <2 x double> %21, <2 x i32> <i32 0, i32 2>
  %25 = insertelement <2 x double> %19, double 0.000000e+00, i32 1
  %26 = fdiv <2 x double> %24, %25
  %27 = fmul <2 x double> %24, %25
  %28 = shufflevector <2 x double> %26, <2 x double> %27, <2 x i32> <i32 0, i32 3>
  %29 = extractelement <2 x double> %21, i32 1
  %30 = extractelement <2 x double> %26, i32 0
  %31 = shufflevector <2 x double> %21, <2 x double> %26, <2 x i32> <i32 1, i32 2>
  %32 = fmul <2 x double> %31, zeroinitializer
  %33 = fsub <2 x double> %28, %32
  %34 = extractelement <2 x double> %32, i32 0
  %35 = fsub double %34, %23
  %36 = insertelement <2 x double> undef, double %35, i32 0
  %37 = extractelement <2 x double> %33, i32 0
  %38 = shufflevector <2 x double> %36, <2 x double> %33, <2 x i32> <i32 0, i32 2>
  %39 = fmul <2 x double> %31, %38
  %40 = shufflevector <2 x double> %26, <2 x double> %21, <2 x i32> <i32 0, i32 2>
  %41 = extractelement <2 x double> %33, i32 1
  %42 = insertelement <2 x double> undef, double %41, i32 0
  %43 = insertelement <2 x double> %42, double %35, i32 1
  %44 = fmul <2 x double> %40, %43
  %45 = fsub <2 x double> %39, %44
  %46 = fmul double %23, %41
  %47 = fmul double %29, %37
  %48 = fsub double %46, %47
  %49 = fptrunc <2 x double> %33 to <2 x float>
  %50 = fptrunc <2 x double> %45 to <2 x float>
  %51 = fptrunc <2 x double> %21 to <2 x float>
  %52 = fptrunc double %35 to float
  %53 = fptrunc double %48 to float
  %54 = fptrunc double %30 to float
  %55 = getelementptr inbounds %struct.ray, %struct.ray* %0, i64 0, i32 0, i32 2
  %56 = bitcast %struct.ray* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %56, i8 0, i64 24, i1 false)
  %57 = load double, double* @get_sample_pos.sf, align 8, !tbaa !22, !noalias !38
  %58 = fcmp oeq double %57, 0.000000e+00
  %59 = load i32, i32* @xres, align 4, !tbaa !2, !noalias !38
  %60 = sitofp i32 %59 to double
  br i1 %58, label %61, label %63

61:                                               ; preds = %4
  %62 = fdiv double 2.000000e+00, %60
  store double %62, double* @get_sample_pos.sf, align 8, !tbaa !22, !noalias !38
  br label %63

63:                                               ; preds = %61, %4
  %64 = phi double [ %62, %61 ], [ %57, %4 ]
  %65 = sitofp i32 %1 to double
  %66 = fdiv double %65, %60
  %67 = fadd double %66, -5.000000e-01
  %68 = sitofp i32 %2 to double
  %69 = load i32, i32* @yres, align 4, !tbaa !2, !noalias !38
  %70 = sitofp i32 %69 to double
  %71 = fdiv double %68, %70
  %72 = fadd double %71, -6.500000e-01
  %73 = fsub double -0.000000e+00, %72
  %74 = load double, double* @aspect, align 8, !tbaa !22, !noalias !38
  %75 = fdiv double %73, %74
  %76 = icmp eq i32 %3, 0
  br i1 %76, label %107, label %77

77:                                               ; preds = %63
  %78 = shl i32 %2, 2
  %79 = add nsw i32 %78, %1
  %80 = add nsw i32 %3, %1
  %81 = and i32 %80, 1023
  %82 = zext i32 %81 to i64
  %83 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %82
  %84 = load i32, i32* %83, align 4, !tbaa !2, !noalias !41
  %85 = add nsw i32 %79, %84
  %86 = and i32 %85, 1023
  %87 = zext i32 %86 to i64
  %88 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %87, i32 0
  %89 = load double, double* %88, align 8, !tbaa !6, !noalias !41
  %90 = shl i32 %1, 2
  %91 = add nsw i32 %90, %2
  %92 = add nsw i32 %3, %2
  %93 = and i32 %92, 1023
  %94 = zext i32 %93 to i64
  %95 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %94
  %96 = load i32, i32* %95, align 4, !tbaa !2, !noalias !41
  %97 = add nsw i32 %91, %96
  %98 = and i32 %97, 1023
  %99 = zext i32 %98 to i64
  %100 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %99, i32 1
  %101 = load double, double* %100, align 8, !tbaa !9, !noalias !41
  %102 = fmul double %64, %89
  %103 = fadd double %67, %102
  %104 = fmul double %64, %101
  %105 = fdiv double %104, %74
  %106 = fadd double %75, %105
  br label %107

107:                                              ; preds = %63, %77
  %108 = phi double [ %75, %63 ], [ %106, %77 ]
  %109 = phi double [ %67, %63 ], [ %103, %77 ]
  %110 = getelementptr inbounds %struct.ray, %struct.ray* %0, i64 0, i32 1, i32 1
  %111 = fmul double %109, 1.000000e+03
  %112 = fmul double %108, 1.000000e+03
  %113 = fadd double %111, 0.000000e+00
  %114 = fadd double %112, 0.000000e+00
  %115 = fpext <2 x float> %49 to <2 x double>
  %116 = fpext <2 x float> %50 to <2 x double>
  %117 = fpext <2 x float> %51 to <2 x double>
  %118 = extractelement <2 x double> %115, i32 1
  %119 = extractelement <2 x double> %116, i32 1
  %120 = extractelement <2 x double> %117, i32 1
  %121 = fpext float %52 to double
  %122 = insertelement <2 x double> undef, double %113, i32 0
  %123 = shufflevector <2 x double> %122, <2 x double> undef, <2 x i32> zeroinitializer
  %124 = insertelement <2 x double> undef, double %118, i32 0
  %125 = insertelement <2 x double> %124, double %121, i32 1
  %126 = fmul <2 x double> %123, %125
  %127 = fpext float %53 to double
  %128 = insertelement <2 x double> undef, double %114, i32 0
  %129 = shufflevector <2 x double> %128, <2 x double> undef, <2 x i32> zeroinitializer
  %130 = insertelement <2 x double> undef, double %119, i32 0
  %131 = insertelement <2 x double> %130, double %127, i32 1
  %132 = fmul <2 x double> %129, %131
  %133 = fadd <2 x double> %132, %126
  %134 = fpext float %54 to double
  %135 = insertelement <2 x double> undef, double %120, i32 0
  %136 = insertelement <2 x double> %135, double %134, i32 1
  %137 = fmul <2 x double> %136, <double 0x40A3E4F54CA8ABFE, double 0x40A3E4F54CA8ABFE>
  %138 = fadd <2 x double> %137, %133
  %139 = fmul <2 x double> %115, zeroinitializer
  %140 = fmul <2 x double> %116, zeroinitializer
  %141 = fadd <2 x double> %139, %140
  %142 = fmul <2 x double> %117, zeroinitializer
  %143 = fadd <2 x double> %142, %141
  %144 = load <2 x double>, <2 x double>* bitcast (%struct.camera* @cam to <2 x double>*), align 8, !tbaa !22
  %145 = fadd <2 x double> %143, %144
  %146 = insertelement <2 x double> undef, double %121, i32 0
  %147 = insertelement <2 x double> %146, double %114, i32 1
  %148 = shufflevector <2 x double> <double 0.000000e+00, double undef>, <2 x double> %116, <2 x i32> <i32 0, i32 2>
  %149 = fmul <2 x double> %147, %148
  %150 = insertelement <2 x double> undef, double %127, i32 0
  %151 = insertelement <2 x double> %150, double %113, i32 1
  %152 = shufflevector <2 x double> <double 0.000000e+00, double undef>, <2 x double> %115, <2 x i32> <i32 0, i32 2>
  %153 = fmul <2 x double> %151, %152
  %154 = fadd <2 x double> %149, %153
  %155 = insertelement <2 x double> undef, double %134, i32 0
  %156 = shufflevector <2 x double> %155, <2 x double> %117, <2 x i32> <i32 0, i32 2>
  %157 = fmul <2 x double> %156, <double 0.000000e+00, double 0x40A3E4F54CA8ABFE>
  %158 = fadd <2 x double> %157, %154
  %159 = load double, double* getelementptr inbounds (%struct.camera, %struct.camera* @cam, i64 0, i32 0, i32 2), align 8, !tbaa !37
  %160 = bitcast %struct.ray* %0 to <2 x double>*
  store <2 x double> %145, <2 x double>* %160, align 8
  %161 = insertelement <2 x double> undef, double %159, i32 0
  %162 = shufflevector <2 x double> %161, <2 x double> %145, <2 x i32> <i32 0, i32 2>
  %163 = fadd <2 x double> %158, %162
  %164 = bitcast double* %55 to <2 x double>*
  store <2 x double> %163, <2 x double>* %164, align 8
  %165 = shufflevector <2 x double> %145, <2 x double> %163, <2 x i32> <i32 1, i32 2>
  %166 = fadd <2 x double> %138, %165
  %167 = bitcast double* %110 to <2 x double>*
  store <2 x double> %166, <2 x double>* %167, align 8, !tbaa !22
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @ray_sphere(%struct.sphere* nocapture readonly, %struct.ray* nocapture readonly byval(%struct.ray) align 8, %struct.spoint*) local_unnamed_addr #0 {
  %4 = getelementptr inbounds %struct.ray, %struct.ray* %1, i64 0, i32 1, i32 0
  %5 = bitcast double* %4 to <2 x double>*
  %6 = load <2 x double>, <2 x double>* %5, align 8, !tbaa !22
  %7 = fmul <2 x double> %6, %6
  %8 = extractelement <2 x double> %7, i32 0
  %9 = extractelement <2 x double> %7, i32 1
  %10 = fadd double %8, %9
  %11 = getelementptr inbounds %struct.ray, %struct.ray* %1, i64 0, i32 1, i32 2
  %12 = load double, double* %11, align 8, !tbaa !44
  %13 = fmul double %12, %12
  %14 = fadd double %10, %13
  %15 = bitcast %struct.ray* %1 to <2 x double>*
  %16 = load <2 x double>, <2 x double>* %15, align 8, !tbaa !22
  %17 = bitcast %struct.sphere* %0 to <2 x double>*
  %18 = load <2 x double>, <2 x double>* %17, align 8, !tbaa !22
  %19 = fmul <2 x double> %6, <double 2.000000e+00, double 2.000000e+00>
  %20 = fsub <2 x double> %16, %18
  %21 = fmul <2 x double> %19, %20
  %22 = extractelement <2 x double> %21, i32 0
  %23 = extractelement <2 x double> %21, i32 1
  %24 = fadd double %22, %23
  %25 = fmul double %12, 2.000000e+00
  %26 = getelementptr inbounds %struct.ray, %struct.ray* %1, i64 0, i32 0, i32 2
  %27 = load double, double* %26, align 8, !tbaa !46
  %28 = getelementptr inbounds %struct.sphere, %struct.sphere* %0, i64 0, i32 0, i32 2
  %29 = load double, double* %28, align 8, !tbaa !47
  %30 = fsub double %27, %29
  %31 = fmul double %25, %30
  %32 = fadd double %24, %31
  %33 = fmul <2 x double> %18, %18
  %34 = extractelement <2 x double> %33, i32 0
  %35 = extractelement <2 x double> %33, i32 1
  %36 = fadd double %34, %35
  %37 = fmul double %29, %29
  %38 = fadd double %36, %37
  %39 = fmul <2 x double> %16, %16
  %40 = extractelement <2 x double> %39, i32 0
  %41 = fadd double %40, %38
  %42 = extractelement <2 x double> %39, i32 1
  %43 = fadd double %42, %41
  %44 = fmul double %27, %27
  %45 = fadd double %44, %43
  %46 = fmul <2 x double> %16, %18
  %47 = extractelement <2 x double> %46, i32 0
  %48 = fsub double -0.000000e+00, %47
  %49 = extractelement <2 x double> %46, i32 1
  %50 = fsub double %48, %49
  %51 = fmul double %27, %29
  %52 = fsub double %50, %51
  %53 = fmul double %52, 2.000000e+00
  %54 = fadd double %53, %45
  %55 = getelementptr inbounds %struct.sphere, %struct.sphere* %0, i64 0, i32 1
  %56 = load double, double* %55, align 8, !tbaa !26
  %57 = fmul double %56, %56
  %58 = fsub double %54, %57
  %59 = fmul double %32, %32
  %60 = fmul double %14, 4.000000e+00
  %61 = fmul double %60, %58
  %62 = fsub double %59, %61
  %63 = fcmp olt double %62, 0.000000e+00
  br i1 %63, label %151, label %64

64:                                               ; preds = %3
  %65 = tail call double @sqrt(double %62) #6
  %66 = fsub double -0.000000e+00, %32
  %67 = fmul double %14, 2.000000e+00
  %68 = insertelement <2 x double> undef, double %65, i32 0
  %69 = insertelement <2 x double> %68, double %66, i32 1
  %70 = insertelement <2 x double> undef, double %32, i32 0
  %71 = insertelement <2 x double> %70, double %65, i32 1
  %72 = fsub <2 x double> %69, %71
  %73 = insertelement <2 x double> undef, double %67, i32 0
  %74 = shufflevector <2 x double> %73, <2 x double> undef, <2 x i32> zeroinitializer
  %75 = fdiv <2 x double> %72, %74
  %76 = extractelement <2 x double> %75, i32 0
  %77 = fcmp olt double %76, 0x3EB0C6F7A0B5ED8D
  %78 = extractelement <2 x double> %75, i32 1
  %79 = fcmp olt double %78, 0x3EB0C6F7A0B5ED8D
  %80 = and i1 %77, %79
  br i1 %80, label %151, label %81

81:                                               ; preds = %64
  %82 = fcmp ogt <2 x double> %75, <double 1.000000e+00, double 1.000000e+00>
  %83 = extractelement <2 x i1> %82, i32 0
  %84 = extractelement <2 x i1> %82, i32 1
  %85 = and i1 %83, %84
  br i1 %85, label %151, label %86

86:                                               ; preds = %81
  %87 = icmp eq %struct.spoint* %2, null
  br i1 %87, label %151, label %88

88:                                               ; preds = %86
  %89 = select i1 %77, double %78, double %76
  %90 = select i1 %79, double %89, double %78
  %91 = fcmp olt double %89, %90
  %92 = select i1 %91, double %89, double %90
  %93 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 3
  store double %92, double* %93, align 8, !tbaa !32
  %94 = insertelement <2 x double> undef, double %92, i32 0
  %95 = shufflevector <2 x double> %94, <2 x double> undef, <2 x i32> zeroinitializer
  %96 = fmul <2 x double> %6, %95
  %97 = fadd <2 x double> %16, %96
  %98 = bitcast %struct.spoint* %2 to <2 x double>*
  store <2 x double> %97, <2 x double>* %98, align 8, !tbaa !22
  %99 = fmul double %12, %92
  %100 = fadd double %27, %99
  %101 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 0, i32 2
  store double %100, double* %101, align 8, !tbaa !48
  %102 = load double, double* %55, align 8, !tbaa !26
  %103 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 1, i32 0
  %104 = bitcast %struct.sphere* %0 to <2 x double>*
  %105 = load <2 x double>, <2 x double>* %104, align 8, !tbaa !22
  %106 = fsub <2 x double> %97, %105
  %107 = insertelement <2 x double> undef, double %102, i32 0
  %108 = shufflevector <2 x double> %107, <2 x double> undef, <2 x i32> zeroinitializer
  %109 = fdiv <2 x double> %106, %108
  %110 = bitcast double* %103 to <2 x double>*
  store <2 x double> %109, <2 x double>* %110, align 8, !tbaa !22
  %111 = load double, double* %28, align 8, !tbaa !47
  %112 = fsub double %100, %111
  %113 = fdiv double %112, %102
  %114 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 1, i32 2
  store double %113, double* %114, align 8, !tbaa !49
  %115 = extractelement <2 x double> %6, i32 0
  %116 = extractelement <2 x double> %109, i32 0
  %117 = fmul double %116, %115
  %118 = extractelement <2 x double> %6, i32 1
  %119 = extractelement <2 x double> %109, i32 1
  %120 = fmul double %118, %119
  %121 = fadd double %120, %117
  %122 = fmul double %12, %113
  %123 = fadd double %122, %121
  %124 = fmul double %123, 2.000000e+00
  %125 = insertelement <2 x double> undef, double %124, i32 0
  %126 = shufflevector <2 x double> %125, <2 x double> undef, <2 x i32> zeroinitializer
  %127 = fmul <2 x double> %109, %126
  %128 = fsub <2 x double> %127, %6
  %129 = fsub <2 x double> <double -0.000000e+00, double -0.000000e+00>, %128
  %130 = fmul double %113, %124
  %131 = fsub double %130, %12
  %132 = fsub double -0.000000e+00, %131
  %133 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 0
  %134 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 1
  %135 = bitcast double* %133 to <2 x double>*
  store <2 x double> %129, <2 x double>* %135, align 8
  %136 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 2
  store double %132, double* %136, align 8
  %137 = extractelement <2 x double> %128, i32 0
  %138 = fmul double %137, %137
  %139 = extractelement <2 x double> %128, i32 1
  %140 = fmul double %139, %139
  %141 = fadd double %138, %140
  %142 = fmul double %131, %131
  %143 = fadd double %142, %141
  %144 = tail call double @sqrt(double %143) #6
  %145 = load double, double* %133, align 8, !tbaa !50
  %146 = fdiv double %145, %144
  store double %146, double* %133, align 8, !tbaa !50
  %147 = load double, double* %134, align 8, !tbaa !51
  %148 = fdiv double %147, %144
  store double %148, double* %134, align 8, !tbaa !51
  %149 = load double, double* %136, align 8, !tbaa !52
  %150 = fdiv double %149, %144
  store double %150, double* %136, align 8, !tbaa !52
  br label %151

151:                                              ; preds = %88, %86, %64, %81, %3
  %152 = phi i32 [ 0, %3 ], [ 0, %81 ], [ 0, %64 ], [ 1, %86 ], [ 1, %88 ]
  ret i32 %152
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #1

; Function Attrs: nounwind uwtable
define dso_local void @shade(%struct.vec3* noalias nocapture sret, %struct.sphere* nocapture readonly, %struct.spoint* nocapture readonly, i32) local_unnamed_addr #0 {
  %5 = alloca %struct.spoint, align 8
  %6 = alloca %struct.spoint, align 8
  %7 = alloca %struct.vec3, align 16
  %8 = alloca %struct.ray, align 8
  %9 = bitcast %struct.vec3* %0 to i8*
  tail call void @llvm.memset.p0i8.i64(i8* align 8 %9, i8 0, i64 24, i1 false)
  %10 = load i32, i32* @lnum, align 4, !tbaa !2
  %11 = icmp sgt i32 %10, 0
  br i1 %11, label %12, label %189

12:                                               ; preds = %4
  %13 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 0, i32 0
  %14 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 0, i32 1
  %15 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 0, i32 2
  %16 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 1, i32 0
  %17 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 1, i32 1
  %18 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 1, i32 2
  %19 = getelementptr inbounds %struct.sphere, %struct.sphere* %1, i64 0, i32 2, i32 1
  %20 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 0
  %21 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 1
  %22 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 2
  %23 = getelementptr inbounds %struct.sphere, %struct.sphere* %1, i64 0, i32 2, i32 0, i32 0
  %24 = getelementptr inbounds %struct.sphere, %struct.sphere* %1, i64 0, i32 2, i32 0, i32 2
  %25 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 2
  %26 = bitcast double* %23 to <2 x double>*
  %27 = bitcast %struct.vec3* %0 to <2 x double>*
  br label %28

28:                                               ; preds = %12, %182
  %29 = phi double [ 0.000000e+00, %12 ], [ %183, %182 ]
  %30 = phi i64 [ 0, %12 ], [ %185, %182 ]
  %31 = phi <2 x double> [ zeroinitializer, %12 ], [ %184, %182 ]
  %32 = load %struct.sphere*, %struct.sphere** @obj_list, align 8, !tbaa !16
  %33 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %30, i32 0
  %34 = load double, double* %33, align 8, !tbaa !6
  %35 = load double, double* %13, align 8, !tbaa !53
  %36 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %30, i32 1
  %37 = load double, double* %36, align 8, !tbaa !9
  %38 = load double, double* %14, align 8, !tbaa !54
  %39 = fsub double %37, %38
  %40 = getelementptr inbounds [16 x %struct.vec3], [16 x %struct.vec3]* @lights, i64 0, i64 %30, i32 2
  %41 = load double, double* %40, align 8, !tbaa !35
  %42 = load double, double* %15, align 8, !tbaa !48
  %43 = insertelement <2 x double> undef, double %34, i32 0
  %44 = insertelement <2 x double> %43, double %41, i32 1
  %45 = insertelement <2 x double> undef, double %35, i32 0
  %46 = insertelement <2 x double> %45, double %42, i32 1
  %47 = fsub <2 x double> %44, %46
  %48 = getelementptr inbounds %struct.sphere, %struct.sphere* %32, i64 0, i32 3
  %49 = load %struct.sphere*, %struct.sphere** %48, align 8, !tbaa !18
  %50 = icmp eq %struct.sphere* %49, null
  %51 = extractelement <2 x double> %47, i32 0
  %52 = fmul double %51, %51
  %53 = fmul double %39, %39
  %54 = fadd double %52, %53
  %55 = extractelement <2 x double> %47, i32 1
  %56 = fmul double %55, %55
  %57 = fadd double %54, %56
  br i1 %50, label %133, label %58

58:                                               ; preds = %28
  %59 = fmul double %39, 2.000000e+00
  %60 = fmul <2 x double> %47, <double 2.000000e+00, double 2.000000e+00>
  %61 = fmul double %35, %35
  %62 = fmul double %38, %38
  %63 = fmul double %42, %42
  %64 = fmul double %57, 4.000000e+00
  %65 = fmul double %57, 2.000000e+00
  %66 = insertelement <2 x double> undef, double %65, i32 0
  %67 = shufflevector <2 x double> %66, <2 x double> undef, <2 x i32> zeroinitializer
  br label %68

68:                                               ; preds = %58, %129
  %69 = phi %struct.sphere* [ %49, %58 ], [ %131, %129 ]
  %70 = getelementptr inbounds %struct.sphere, %struct.sphere* %69, i64 0, i32 0, i32 0
  %71 = load double, double* %70, align 8, !tbaa !55
  %72 = getelementptr inbounds %struct.sphere, %struct.sphere* %69, i64 0, i32 0, i32 1
  %73 = load double, double* %72, align 8, !tbaa !56
  %74 = fsub double %38, %73
  %75 = fmul double %59, %74
  %76 = getelementptr inbounds %struct.sphere, %struct.sphere* %69, i64 0, i32 0, i32 2
  %77 = load double, double* %76, align 8, !tbaa !47
  %78 = insertelement <2 x double> undef, double %71, i32 0
  %79 = insertelement <2 x double> %78, double %77, i32 1
  %80 = fsub <2 x double> %46, %79
  %81 = fmul <2 x double> %60, %80
  %82 = extractelement <2 x double> %81, i32 0
  %83 = fadd double %82, %75
  %84 = extractelement <2 x double> %81, i32 1
  %85 = fadd double %83, %84
  %86 = fmul double %71, %71
  %87 = fmul double %73, %73
  %88 = fadd double %86, %87
  %89 = fmul double %77, %77
  %90 = fadd double %88, %89
  %91 = fadd double %61, %90
  %92 = fadd double %62, %91
  %93 = fadd double %63, %92
  %94 = fmul double %35, %71
  %95 = fsub double -0.000000e+00, %94
  %96 = fmul double %38, %73
  %97 = fsub double %95, %96
  %98 = fmul double %42, %77
  %99 = fsub double %97, %98
  %100 = fmul double %99, 2.000000e+00
  %101 = fadd double %100, %93
  %102 = getelementptr inbounds %struct.sphere, %struct.sphere* %69, i64 0, i32 1
  %103 = load double, double* %102, align 8, !tbaa !26
  %104 = fmul double %103, %103
  %105 = fsub double %101, %104
  %106 = fmul double %85, %85
  %107 = fmul double %64, %105
  %108 = fsub double %106, %107
  %109 = fcmp olt double %108, 0.000000e+00
  br i1 %109, label %129, label %110

110:                                              ; preds = %68
  %111 = tail call double @sqrt(double %108) #6
  %112 = fsub double -0.000000e+00, %85
  %113 = insertelement <2 x double> undef, double %111, i32 0
  %114 = insertelement <2 x double> %113, double %112, i32 1
  %115 = insertelement <2 x double> undef, double %85, i32 0
  %116 = insertelement <2 x double> %115, double %111, i32 1
  %117 = fsub <2 x double> %114, %116
  %118 = fdiv <2 x double> %117, %67
  %119 = extractelement <2 x double> %118, i32 0
  %120 = fcmp olt double %119, 0x3EB0C6F7A0B5ED8D
  %121 = extractelement <2 x double> %118, i32 1
  %122 = fcmp olt double %121, 0x3EB0C6F7A0B5ED8D
  %123 = and i1 %120, %122
  br i1 %123, label %129, label %124

124:                                              ; preds = %110
  %125 = fcmp ogt <2 x double> %118, <double 1.000000e+00, double 1.000000e+00>
  %126 = extractelement <2 x i1> %125, i32 0
  %127 = extractelement <2 x i1> %125, i32 1
  %128 = and i1 %126, %127
  br i1 %128, label %129, label %182

129:                                              ; preds = %68, %124, %110
  %130 = getelementptr inbounds %struct.sphere, %struct.sphere* %69, i64 0, i32 3
  %131 = load %struct.sphere*, %struct.sphere** %130, align 8, !tbaa !18
  %132 = icmp eq %struct.sphere* %131, null
  br i1 %132, label %133, label %68

133:                                              ; preds = %129, %28
  %134 = tail call double @sqrt(double %57) #6
  %135 = fdiv double %39, %134
  %136 = insertelement <2 x double> undef, double %134, i32 0
  %137 = shufflevector <2 x double> %136, <2 x double> undef, <2 x i32> zeroinitializer
  %138 = fdiv <2 x double> %47, %137
  %139 = load double, double* %16, align 8, !tbaa !57
  %140 = extractelement <2 x double> %138, i32 0
  %141 = fmul double %139, %140
  %142 = load double, double* %17, align 8, !tbaa !58
  %143 = fmul double %135, %142
  %144 = fadd double %141, %143
  %145 = load double, double* %18, align 8, !tbaa !49
  %146 = extractelement <2 x double> %138, i32 1
  %147 = fmul double %146, %145
  %148 = fadd double %144, %147
  %149 = fcmp ogt double %148, 0.000000e+00
  %150 = select i1 %149, double %148, double 0.000000e+00
  %151 = load double, double* %19, align 8, !tbaa !27
  %152 = fcmp ogt double %151, 0.000000e+00
  br i1 %152, label %153, label %168

153:                                              ; preds = %133
  %154 = load double, double* %20, align 8, !tbaa !50
  %155 = load double, double* %21, align 8, !tbaa !51
  %156 = fmul double %135, %155
  %157 = load double, double* %22, align 8, !tbaa !52
  %158 = insertelement <2 x double> undef, double %154, i32 0
  %159 = insertelement <2 x double> %158, double %157, i32 1
  %160 = fmul <2 x double> %138, %159
  %161 = extractelement <2 x double> %160, i32 0
  %162 = fadd double %161, %156
  %163 = extractelement <2 x double> %160, i32 1
  %164 = fadd double %162, %163
  %165 = fcmp ogt double %164, 0.000000e+00
  %166 = select i1 %165, double %164, double 0.000000e+00
  %167 = tail call double @pow(double %166, double %151) #6
  br label %168

168:                                              ; preds = %133, %153
  %169 = phi double [ %167, %153 ], [ 0.000000e+00, %133 ]
  %170 = load <2 x double>, <2 x double>* %26, align 8, !tbaa !22
  %171 = insertelement <2 x double> undef, double %150, i32 0
  %172 = shufflevector <2 x double> %171, <2 x double> undef, <2 x i32> zeroinitializer
  %173 = fmul <2 x double> %172, %170
  %174 = insertelement <2 x double> undef, double %169, i32 0
  %175 = shufflevector <2 x double> %174, <2 x double> undef, <2 x i32> zeroinitializer
  %176 = fadd <2 x double> %175, %173
  %177 = fadd <2 x double> %31, %176
  store <2 x double> %177, <2 x double>* %27, align 8, !tbaa !22
  %178 = load double, double* %24, align 8, !tbaa !59
  %179 = fmul double %150, %178
  %180 = fadd double %169, %179
  %181 = fadd double %29, %180
  store double %181, double* %25, align 8, !tbaa !35
  br label %182

182:                                              ; preds = %124, %168
  %183 = phi double [ %181, %168 ], [ %29, %124 ]
  %184 = phi <2 x double> [ %177, %168 ], [ %31, %124 ]
  %185 = add nuw nsw i64 %30, 1
  %186 = load i32, i32* @lnum, align 4, !tbaa !2
  %187 = sext i32 %186 to i64
  %188 = icmp slt i64 %185, %187
  br i1 %188, label %28, label %189

189:                                              ; preds = %182, %4
  %190 = phi double [ 0.000000e+00, %4 ], [ %183, %182 ]
  %191 = phi <2 x double> [ zeroinitializer, %4 ], [ %184, %182 ]
  %192 = getelementptr inbounds %struct.sphere, %struct.sphere* %1, i64 0, i32 2, i32 2
  %193 = load double, double* %192, align 8, !tbaa !28
  %194 = fcmp ogt double %193, 0.000000e+00
  br i1 %194, label %195, label %257

195:                                              ; preds = %189
  %196 = bitcast %struct.spoint* %2 to i8*
  %197 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 0
  %198 = bitcast double* %197 to <2 x double>*
  %199 = load <2 x double>, <2 x double>* %198, align 8
  %200 = getelementptr inbounds %struct.spoint, %struct.spoint* %2, i64 0, i32 2, i32 2
  %201 = load double, double* %200, align 8
  %202 = fmul <2 x double> %199, <double 1.000000e+03, double 1.000000e+03>
  %203 = fmul double %201, 1.000000e+03
  %204 = add nsw i32 %3, 1
  %205 = bitcast %struct.ray* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %205)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %205, i8* align 8 %196, i64 24, i1 false)
  %206 = getelementptr inbounds %struct.ray, %struct.ray* %8, i64 0, i32 1, i32 0
  %207 = bitcast double* %206 to <2 x double>*
  store <2 x double> %202, <2 x double>* %207, align 8
  %208 = getelementptr inbounds %struct.ray, %struct.ray* %8, i64 0, i32 1, i32 2
  store double %203, double* %208, align 8
  %209 = bitcast %struct.spoint* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %209) #6, !noalias !60
  %210 = bitcast %struct.spoint* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %210) #6, !noalias !60
  %211 = icmp sgt i32 %3, 3
  br i1 %211, label %245, label %212

212:                                              ; preds = %195
  %213 = load %struct.sphere*, %struct.sphere** @obj_list, align 8, !tbaa !16, !noalias !60
  %214 = getelementptr inbounds %struct.sphere, %struct.sphere* %213, i64 0, i32 3
  %215 = load %struct.sphere*, %struct.sphere** %214, align 8, !tbaa !18, !noalias !60
  %216 = icmp eq %struct.sphere* %215, null
  br i1 %216, label %245, label %217

217:                                              ; preds = %212
  %218 = getelementptr inbounds %struct.spoint, %struct.spoint* %5, i64 0, i32 3
  %219 = getelementptr inbounds %struct.spoint, %struct.spoint* %6, i64 0, i32 3
  br label %220

220:                                              ; preds = %217, %232
  %221 = phi %struct.sphere* [ %215, %217 ], [ %235, %232 ]
  %222 = phi %struct.sphere* [ null, %217 ], [ %233, %232 ]
  %223 = call i32 @ray_sphere(%struct.sphere* nonnull %221, %struct.ray* nonnull byval(%struct.ray) align 8 %8, %struct.spoint* nonnull %5) #6, !noalias !60
  %224 = icmp eq i32 %223, 0
  br i1 %224, label %232, label %225

225:                                              ; preds = %220
  %226 = icmp eq %struct.sphere* %222, null
  br i1 %226, label %231, label %227

227:                                              ; preds = %225
  %228 = load double, double* %218, align 8, !tbaa !32, !noalias !60
  %229 = load double, double* %219, align 8, !tbaa !32, !noalias !60
  %230 = fcmp olt double %228, %229
  br i1 %230, label %231, label %232

231:                                              ; preds = %227, %225
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %210, i8* nonnull align 8 %209, i64 80, i1 false) #6, !tbaa.struct !34, !noalias !60
  br label %232

232:                                              ; preds = %231, %227, %220
  %233 = phi %struct.sphere* [ %221, %231 ], [ %222, %227 ], [ %222, %220 ]
  %234 = getelementptr inbounds %struct.sphere, %struct.sphere* %221, i64 0, i32 3
  %235 = load %struct.sphere*, %struct.sphere** %234, align 8, !tbaa !18, !noalias !60
  %236 = icmp eq %struct.sphere* %235, null
  br i1 %236, label %237, label %220

237:                                              ; preds = %232
  %238 = icmp eq %struct.sphere* %233, null
  br i1 %238, label %245, label %239

239:                                              ; preds = %237
  %240 = bitcast %struct.vec3* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %240) #6, !noalias !60
  call void @shade(%struct.vec3* nonnull sret %7, %struct.sphere* nonnull %233, %struct.spoint* nonnull %6, i32 %204) #6, !noalias !60
  %241 = bitcast %struct.vec3* %7 to <2 x double>*
  %242 = load <2 x double>, <2 x double>* %241, align 16
  %243 = getelementptr inbounds %struct.vec3, %struct.vec3* %7, i64 0, i32 2
  %244 = load double, double* %243, align 16
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %240) #6, !noalias !60
  br label %245

245:                                              ; preds = %212, %237, %195, %239
  %246 = phi double [ %244, %239 ], [ 0.000000e+00, %195 ], [ 0.000000e+00, %237 ], [ 0.000000e+00, %212 ]
  %247 = phi <2 x double> [ %242, %239 ], [ zeroinitializer, %195 ], [ zeroinitializer, %237 ], [ zeroinitializer, %212 ]
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %210) #6, !noalias !60
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %209) #6, !noalias !60
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %205)
  %248 = load double, double* %192, align 8, !tbaa !28
  %249 = insertelement <2 x double> undef, double %248, i32 0
  %250 = shufflevector <2 x double> %249, <2 x double> undef, <2 x i32> zeroinitializer
  %251 = fmul <2 x double> %247, %250
  %252 = fadd <2 x double> %191, %251
  %253 = bitcast %struct.vec3* %0 to <2 x double>*
  store <2 x double> %252, <2 x double>* %253, align 8, !tbaa !22
  %254 = fmul double %246, %248
  %255 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 2
  %256 = fadd double %254, %190
  store double %256, double* %255, align 8, !tbaa !35
  br label %257

257:                                              ; preds = %245, %189
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: nofree nounwind
declare dso_local double @sqrt(double) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local double @pow(double, double) local_unnamed_addr #2

; Function Attrs: nofree norecurse nounwind uwtable
define dso_local void @reflect(%struct.vec3* noalias nocapture sret, %struct.vec3* nocapture readonly byval(%struct.vec3) align 8, %struct.vec3* nocapture readonly byval(%struct.vec3) align 8) local_unnamed_addr #4 {
  %4 = bitcast %struct.vec3* %1 to <2 x double>*
  %5 = load <2 x double>, <2 x double>* %4, align 8, !tbaa !22
  %6 = bitcast %struct.vec3* %2 to <2 x double>*
  %7 = load <2 x double>, <2 x double>* %6, align 8, !tbaa !22
  %8 = extractelement <2 x double> %7, i32 0
  %9 = extractelement <2 x double> %5, i32 0
  %10 = fmul double %9, %8
  %11 = extractelement <2 x double> %7, i32 1
  %12 = extractelement <2 x double> %5, i32 1
  %13 = fmul double %12, %11
  %14 = fadd double %10, %13
  %15 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i64 0, i32 2
  %16 = load double, double* %15, align 8, !tbaa !35
  %17 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i64 0, i32 2
  %18 = load double, double* %17, align 8, !tbaa !35
  %19 = fmul double %16, %18
  %20 = fadd double %14, %19
  %21 = fmul double %20, 2.000000e+00
  %22 = insertelement <2 x double> undef, double %21, i32 0
  %23 = shufflevector <2 x double> %22, <2 x double> undef, <2 x i32> zeroinitializer
  %24 = fmul <2 x double> %7, %23
  %25 = fsub <2 x double> %24, %5
  %26 = fsub <2 x double> <double -0.000000e+00, double -0.000000e+00>, %25
  %27 = bitcast %struct.vec3* %0 to <2 x double>*
  store <2 x double> %26, <2 x double>* %27, align 8, !tbaa !22
  %28 = fmul double %18, %21
  %29 = fsub double %28, %16
  %30 = fsub double -0.000000e+00, %29
  %31 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 2
  store double %30, double* %31, align 8, !tbaa !35
  ret void
}

; Function Attrs: nofree norecurse nounwind uwtable
define dso_local void @cross_product(%struct.vec3* noalias nocapture sret, %struct.vec3* nocapture readonly byval(%struct.vec3) align 8, %struct.vec3* nocapture readonly byval(%struct.vec3) align 8) local_unnamed_addr #4 {
  %4 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i64 0, i32 1
  %5 = bitcast double* %4 to <2 x double>*
  %6 = load <2 x double>, <2 x double>* %5, align 8, !tbaa !22
  %7 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i64 0, i32 1
  %8 = bitcast double* %7 to <2 x double>*
  %9 = load <2 x double>, <2 x double>* %8, align 8, !tbaa !22
  %10 = getelementptr inbounds %struct.vec3, %struct.vec3* %2, i64 0, i32 0
  %11 = load double, double* %10, align 8, !tbaa !6
  %12 = extractelement <2 x double> %9, i32 1
  %13 = insertelement <2 x double> undef, double %12, i32 0
  %14 = insertelement <2 x double> %13, double %11, i32 1
  %15 = fmul <2 x double> %6, %14
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %1, i64 0, i32 0
  %17 = load double, double* %16, align 8, !tbaa !6
  %18 = extractelement <2 x double> %6, i32 1
  %19 = insertelement <2 x double> undef, double %18, i32 0
  %20 = insertelement <2 x double> %19, double %17, i32 1
  %21 = extractelement <2 x double> %9, i32 0
  %22 = fmul <2 x double> %20, %9
  %23 = fsub <2 x double> %15, %22
  %24 = bitcast %struct.vec3* %0 to <2 x double>*
  store <2 x double> %23, <2 x double>* %24, align 8, !tbaa !22
  %25 = fmul double %21, %17
  %26 = extractelement <2 x double> %6, i32 0
  %27 = fmul double %26, %11
  %28 = fsub double %25, %27
  %29 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 2
  store double %28, double* %29, align 8, !tbaa !35
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @get_sample_pos(%struct.vec3* noalias nocapture sret, i32, i32, i32) local_unnamed_addr #0 {
  %5 = load double, double* @get_sample_pos.sf, align 8, !tbaa !22
  %6 = fcmp oeq double %5, 0.000000e+00
  %7 = load i32, i32* @xres, align 4, !tbaa !2
  %8 = sitofp i32 %7 to double
  br i1 %6, label %9, label %11

9:                                                ; preds = %4
  %10 = fdiv double 2.000000e+00, %8
  store double %10, double* @get_sample_pos.sf, align 8, !tbaa !22
  br label %11

11:                                               ; preds = %4, %9
  %12 = phi double [ %10, %9 ], [ %5, %4 ]
  %13 = sitofp i32 %1 to double
  %14 = fdiv double %13, %8
  %15 = fadd double %14, -5.000000e-01
  %16 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 0
  store double %15, double* %16, align 8, !tbaa !6
  %17 = sitofp i32 %2 to double
  %18 = load i32, i32* @yres, align 4, !tbaa !2
  %19 = sitofp i32 %18 to double
  %20 = fdiv double %17, %19
  %21 = fadd double %20, -6.500000e-01
  %22 = fsub double -0.000000e+00, %21
  %23 = load double, double* @aspect, align 8, !tbaa !22
  %24 = fdiv double %22, %23
  %25 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 1
  store double %24, double* %25, align 8, !tbaa !9
  %26 = icmp eq i32 %3, 0
  br i1 %26, label %57, label %27

27:                                               ; preds = %11
  %28 = shl i32 %2, 2
  %29 = add nsw i32 %28, %1
  %30 = add nsw i32 %3, %1
  %31 = and i32 %30, 1023
  %32 = zext i32 %31 to i64
  %33 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %32
  %34 = load i32, i32* %33, align 4, !tbaa !2, !noalias !63
  %35 = add nsw i32 %29, %34
  %36 = and i32 %35, 1023
  %37 = zext i32 %36 to i64
  %38 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %37, i32 0
  %39 = load double, double* %38, align 8, !tbaa !6, !noalias !63
  %40 = shl i32 %1, 2
  %41 = add nsw i32 %40, %2
  %42 = add nsw i32 %3, %2
  %43 = and i32 %42, 1023
  %44 = zext i32 %43 to i64
  %45 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %44
  %46 = load i32, i32* %45, align 4, !tbaa !2, !noalias !63
  %47 = add nsw i32 %41, %46
  %48 = and i32 %47, 1023
  %49 = zext i32 %48 to i64
  %50 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %49, i32 1
  %51 = load double, double* %50, align 8, !tbaa !9, !noalias !63
  %52 = fmul double %39, %12
  %53 = fadd double %15, %52
  store double %53, double* %16, align 8, !tbaa !6
  %54 = fmul double %51, %12
  %55 = fdiv double %54, %23
  %56 = fadd double %24, %55
  store double %56, double* %25, align 8, !tbaa !9
  br label %57

57:                                               ; preds = %11, %27
  ret void
}

; Function Attrs: nofree norecurse nounwind uwtable
define dso_local void @jitter(%struct.vec3* noalias nocapture sret, i32, i32, i32) local_unnamed_addr #4 {
  %5 = shl i32 %2, 2
  %6 = add nsw i32 %5, %1
  %7 = add nsw i32 %3, %1
  %8 = and i32 %7, 1023
  %9 = zext i32 %8 to i64
  %10 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %9
  %11 = load i32, i32* %10, align 4, !tbaa !2
  %12 = add nsw i32 %6, %11
  %13 = and i32 %12, 1023
  %14 = zext i32 %13 to i64
  %15 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %14, i32 0
  %16 = bitcast double* %15 to i64*
  %17 = load i64, i64* %16, align 8, !tbaa !6
  %18 = bitcast %struct.vec3* %0 to i64*
  store i64 %17, i64* %18, align 8, !tbaa !6
  %19 = shl i32 %1, 2
  %20 = add nsw i32 %19, %2
  %21 = add nsw i32 %3, %2
  %22 = and i32 %21, 1023
  %23 = zext i32 %22 to i64
  %24 = getelementptr inbounds [1024 x i32], [1024 x i32]* @irand, i64 0, i64 %23
  %25 = load i32, i32* %24, align 4, !tbaa !2
  %26 = add nsw i32 %20, %25
  %27 = and i32 %26, 1023
  %28 = zext i32 %27 to i64
  %29 = getelementptr inbounds [1024 x %struct.vec3], [1024 x %struct.vec3]* @urand, i64 0, i64 %28, i32 1
  %30 = bitcast double* %29 to i64*
  %31 = load i64, i64* %30, align 8, !tbaa !9
  %32 = getelementptr inbounds %struct.vec3, %struct.vec3* %0, i64 0, i32 1
  %33 = bitcast double* %32 to i64*
  store i64 %31, i64* %33, align 8, !tbaa !9
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local i8* @fgets(i8*, i32, %struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local i8* @strtok(i8*, i8* nocapture readonly) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local i32 @gettimeofday(%struct.timeval* nocapture, %struct.timezone* nocapture) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare dso_local double @strtod(i8* readonly, i8** nocapture) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare i32 @fputc_unlocked(i32, %struct._IO_FILE* nocapture) local_unnamed_addr #5

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-enqcmd,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mpx,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nofree nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-enqcmd,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mpx,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-enqcmd,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mpx,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nofree norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="broadwell" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+bmi,+bmi2,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-cldemote,-clflushopt,-clwb,-clzero,-enqcmd,-fma4,-gfni,-lwp,-movdir64b,-movdiri,-mpx,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-sgx,-sha,-shstk,-sse4a,-tbm,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-xop,-xsavec,-xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }
attributes #7 = { cold }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 9.0.0-2~ubuntu18.04.2 (tags/RELEASE_900/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !8, i64 0}
!7 = !{!"vec3", !8, i64 0, !8, i64 8, !8, i64 16}
!8 = !{!"double", !4, i64 0}
!9 = !{!7, !8, i64 8}
!10 = !{!11, !12, i64 0}
!11 = !{!"timeval", !12, i64 0, !12, i64 8}
!12 = !{!"long", !4, i64 0}
!13 = !{i64 0, i64 8, !14, i64 8, i64 8, !14}
!14 = !{!12, !12, i64 0}
!15 = !{!11, !12, i64 8}
!16 = !{!17, !17, i64 0}
!17 = !{!"any pointer", !4, i64 0}
!18 = !{!19, !17, i64 72}
!19 = !{!"sphere", !7, i64 0, !8, i64 24, !20, i64 32, !17, i64 72}
!20 = !{!"material", !7, i64 0, !8, i64 24, !8, i64 32}
!21 = !{!4, !4, i64 0}
!22 = !{!8, !8, i64 0}
!23 = !{i64 0, i64 8, !22, i64 8, i64 8, !22, i64 16, i64 8, !22}
!24 = !{!25, !8, i64 48}
!25 = !{!"camera", !7, i64 0, !7, i64 24, !8, i64 48}
!26 = !{!19, !8, i64 24}
!27 = !{!19, !8, i64 56}
!28 = !{!19, !8, i64 64}
!29 = !{!30}
!30 = distinct !{!30, !31, !"trace: argument 0"}
!31 = distinct !{!31, !"trace"}
!32 = !{!33, !8, i64 72}
!33 = !{!"spoint", !7, i64 0, !7, i64 24, !7, i64 48, !8, i64 72}
!34 = !{i64 0, i64 8, !22, i64 8, i64 8, !22, i64 16, i64 8, !22, i64 24, i64 8, !22, i64 32, i64 8, !22, i64 40, i64 8, !22, i64 48, i64 8, !22, i64 56, i64 8, !22, i64 64, i64 8, !22, i64 72, i64 8, !22}
!35 = !{!7, !8, i64 16}
!36 = !{!25, !8, i64 40}
!37 = !{!25, !8, i64 16}
!38 = !{!39}
!39 = distinct !{!39, !40, !"get_sample_pos: argument 0"}
!40 = distinct !{!40, !"get_sample_pos"}
!41 = !{!42, !39}
!42 = distinct !{!42, !43, !"jitter: argument 0"}
!43 = distinct !{!43, !"jitter"}
!44 = !{!45, !8, i64 40}
!45 = !{!"ray", !7, i64 0, !7, i64 24}
!46 = !{!45, !8, i64 16}
!47 = !{!19, !8, i64 16}
!48 = !{!33, !8, i64 16}
!49 = !{!33, !8, i64 40}
!50 = !{!33, !8, i64 48}
!51 = !{!33, !8, i64 56}
!52 = !{!33, !8, i64 64}
!53 = !{!33, !8, i64 0}
!54 = !{!33, !8, i64 8}
!55 = !{!19, !8, i64 0}
!56 = !{!19, !8, i64 8}
!57 = !{!33, !8, i64 24}
!58 = !{!33, !8, i64 32}
!59 = !{!19, !8, i64 48}
!60 = !{!61}
!61 = distinct !{!61, !62, !"trace: argument 0"}
!62 = distinct !{!62, !"trace"}
!63 = !{!64}
!64 = distinct !{!64, !65, !"jitter: argument 0"}
!65 = distinct !{!65, !"jitter"}
