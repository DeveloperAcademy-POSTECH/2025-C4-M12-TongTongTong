# 🍉 TongTongTong - 수박 두드리기 앱

수박을 두드려서 소리를 감지하는 인터랙티브 iOS 앱입니다.

## 📱 주요 기능

- **스플래시 화면**: 애니메이션과 함께 앱 로딩
- **메인 게임**: 수박을 두드려서 소리 감지
- **실시간 오디오 모니터링**: 마이크를 통한 소리 레벨 감지
- **시각적 피드백**: 파동 효과와 색상 변화
- **결과 화면**: 과즙 분석 애니메이션

## 🏗️ 프로젝트 구조

```
tongtongtong/
├── tongtongtong/
│   ├── Constants.swift              # 상수 정의
│   ├── Components/                  # 재사용 가능한 컴포넌트
│   │   ├── TitleView.swift         # 타이틀 컴포넌트
│   │   ├── WatermelonView.swift    # 수박 이미지 컴포넌트
│   │   ├── SeedIndicatorView.swift # 씨앗 인디케이터 컴포넌트
│   │   └── WaveBackgroundView.swift # 파동 배경 컴포넌트
│   ├── Views/                      # 메인 뷰들
│   │   ├── ContentView.swift       # 메인 게임 화면
│   │   ├── ResultView.swift        # 결과 화면
│   │   ├── RootView.swift          # 루트 뷰
│   │   └── SplashView.swift        # 스플래시 화면
│   ├── Services/                   # 서비스 클래스들
│   │   └── AudioLevelMonitor.swift # 오디오 모니터링
│   ├── Animations/                 # 애니메이션 컴포넌트
│   │   └── WaveCircle.swift        # 파동 원 애니메이션
│   └── Assets.xcassets/            # 이미지 리소스
```

## 🎨 코드 가독성 개선사항

### 1. **상수 분리**
- 하드코딩된 값들을 `Constants.swift`로 분리
- 색상, 크기, 애니메이션 시간 등을 체계적으로 관리

### 2. **컴포넌트 분리**
- 큰 뷰를 작은 재사용 가능한 컴포넌트로 분리
- 각 컴포넌트의 책임을 명확히 정의

### 3. **코드 구조화**
- MARK 주석을 사용한 섹션 구분
- 프로퍼티와 메서드를 논리적으로 그룹화

### 4. **네이밍 개선**
- 의미있는 상수명과 변수명 사용
- 일관된 네이밍 컨벤션 적용

### 5. **메서드 분리**
- 복잡한 로직을 별도 메서드로 분리
- 각 메서드의 역할을 명확히 정의

## 🛠️ 기술 스택

- **SwiftUI**: UI 프레임워크
- **AVFoundation**: 오디오 처리
- **Combine**: 반응형 프로그래밍

## 🚀 실행 방법

1. Xcode에서 프로젝트 열기
2. 시뮬레이터 또는 실제 기기에서 실행
3. 수박을 탭하여 마이크 권한 허용
4. 수박을 두드려서 소리 감지

## 📝 주요 개선 포인트

### Before (개선 전)
```swift
// 하드코딩된 값들
.frame(width: 140, height: 140)
.font(.system(size: 34, weight: .bold))
DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)

// 복잡한 뷰 구조
VStack {
    // 100+ 라인의 복잡한 UI 코드
}
```

### After (개선 후)
```swift
// 상수 사용
.frame(width: UIConstants.watermelonSize, height: UIConstants.watermelonSize)
.font(.system(size: UIConstants.titleFontSize, weight: .bold))
DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.micMonitoringDuration)

// 컴포넌트 분리
VStack {
    TitleView()
    WatermelonView(isMicActive: isMicActive) { ... }
    SeedIndicatorView(highlightIndex: highlightIndex, indicatorCount: indicatorCount)
}
```

## 🎯 향후 개선 방향

1. **MVVM 패턴 적용**: 뷰모델 분리
2. **단위 테스트 추가**: 코드 품질 향상
3. **접근성 개선**: VoiceOver 지원
4. **국제화**: 다국어 지원
5. **성능 최적화**: 메모리 사용량 개선 