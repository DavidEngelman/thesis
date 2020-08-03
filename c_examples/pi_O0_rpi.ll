; ModuleID = 'pi.c'
source_filename = "pi.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-unknown-linux-gnueabihf"

@.str = private unnamed_addr constant [16 x i8] c"Starting PI...\0A\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c" x=%8.5f y=%8.5f low=%7d j=%7d\0A\00", align 1
@.str.2 = private unnamed_addr constant [33 x i8] c"Pi = %9.6f ztot=%12.2f itot=%8d\0A\00", align 1

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 4
  %6 = alloca float, align 4
  %7 = alloca float, align 4
  %8 = alloca float, align 4
  %9 = alloca float, align 4
  %10 = alloca float, align 4
  %11 = alloca float, align 4
  %12 = alloca float, align 4
  %13 = alloca float, align 4
  %14 = alloca float, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 4
  %20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0))
  store float 0.000000e+00, float* %6, align 4
  store i32 1, i32* %15, align 4
  store i32 1907, i32* %16, align 4
  store float 5.813000e+03, float* %7, align 4
  store float 1.307000e+03, float* %8, align 4
  store float 5.471000e+03, float* %9, align 4
  store i32 1200000, i32* %17, align 4
  store i32 1, i32* %18, align 4
  br label %21

21:                                               ; preds = %67, %2
  %22 = load i32, i32* %18, align 4
  %23 = load i32, i32* %17, align 4
  %24 = icmp sle i32 %22, %23
  br i1 %24, label %25, label %70

25:                                               ; preds = %21
  %26 = load i32, i32* %16, align 4
  %27 = mul nsw i32 27611, %26
  store i32 %27, i32* %19, align 4
  %28 = load i32, i32* %19, align 4
  %29 = load i32, i32* %19, align 4
  %30 = sdiv i32 %29, 74383
  %31 = mul nsw i32 74383, %30
  %32 = sub nsw i32 %28, %31
  store i32 %32, i32* %16, align 4
  %33 = load i32, i32* %16, align 4
  %34 = sitofp i32 %33 to float
  %35 = fpext float %34 to double
  %36 = fdiv double %35, 7.438300e+04
  %37 = fptrunc double %36 to float
  store float %37, float* %10, align 4
  %38 = load float, float* %8, align 4
  %39 = load float, float* %7, align 4
  %40 = fmul float %38, %39
  store float %40, float* %14, align 4
  %41 = load float, float* %14, align 4
  %42 = load float, float* %9, align 4
  %43 = load float, float* %14, align 4
  %44 = load float, float* %9, align 4
  %45 = fdiv float %43, %44
  %46 = fptosi float %45 to i32
  %47 = sitofp i32 %46 to float
  %48 = fmul float %42, %47
  %49 = fsub float %41, %48
  store float %49, float* %7, align 4
  %50 = load float, float* %7, align 4
  %51 = load float, float* %9, align 4
  %52 = fdiv float %50, %51
  store float %52, float* %11, align 4
  %53 = load float, float* %10, align 4
  %54 = load float, float* %10, align 4
  %55 = fmul float %53, %54
  %56 = load float, float* %11, align 4
  %57 = load float, float* %11, align 4
  %58 = fmul float %56, %57
  %59 = fadd float %55, %58
  store float %59, float* %12, align 4
  call void @myadd(float* %6, float* %12)
  %60 = load float, float* %12, align 4
  %61 = fpext float %60 to double
  %62 = fcmp ole double %61, 1.000000e+00
  br i1 %62, label %63, label %66

63:                                               ; preds = %25
  %64 = load i32, i32* %15, align 4
  %65 = add nsw i32 %64, 1
  store i32 %65, i32* %15, align 4
  br label %66

66:                                               ; preds = %63, %25
  br label %67

67:                                               ; preds = %66
  %68 = load i32, i32* %18, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %18, align 4
  br label %21

70:                                               ; preds = %21
  %71 = load float, float* %10, align 4
  %72 = fpext float %71 to double
  %73 = load float, float* %11, align 4
  %74 = fpext float %73 to double
  %75 = load i32, i32* %15, align 4
  %76 = load i32, i32* %18, align 4
  %77 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), double %72, double %74, i32 %75, i32 %76)
  %78 = load i32, i32* %15, align 4
  %79 = sitofp i32 %78 to float
  %80 = fpext float %79 to double
  %81 = fmul double 4.000000e+00, %80
  %82 = load i32, i32* %17, align 4
  %83 = sitofp i32 %82 to float
  %84 = fpext float %83 to double
  %85 = fdiv double %81, %84
  %86 = fptrunc double %85 to float
  store float %86, float* %13, align 4
  %87 = load float, float* %13, align 4
  %88 = fpext float %87 to double
  %89 = load float, float* %6, align 4
  %90 = fpext float %89 to double
  %91 = load i32, i32* %17, align 4
  %92 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.2, i32 0, i32 0), double %88, double %90, i32 %91)
  ret i32 0
}

declare dso_local i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone
define dso_local void @myadd(float*, float*) #0 {
  %3 = alloca float*, align 4
  %4 = alloca float*, align 4
  store float* %0, float** %3, align 4
  store float* %1, float** %4, align 4
  %5 = load float*, float** %3, align 4
  %6 = load float, float* %5, align 4
  %7 = load float*, float** %4, align 4
  %8 = load float, float* %7, align 4
  %9 = fadd float %6, %8
  %10 = load float*, float** %3, align 4
  store float %9, float* %10, align 4
  ret void
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+fp64,+fpregs,+vfp2d16,+vfp2d16sp,+vfp3d16,+vfp3d16sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+fp64,+fpregs,+vfp2d16,+vfp2d16sp,+vfp3d16,+vfp3d16sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"clang version 9.0.0-2~ubuntu18.04.2 (tags/RELEASE_900/final)"}
