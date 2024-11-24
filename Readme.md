# Shorcap iOS

숏캡 어플리케이션 iOS 레포지토리 입니다.

# Application features

<table>
<tr>
    <td>
        <b>선호하는 숏폼카테고리 선택</b>
    </td>
    <td>
        <b>익스텐션 앱을 사용한 요약</b>
    </td>
</tr>    
    <tr>
        <td>
            <img src="https://github.com/user-attachments/assets/0b37db05-d2ca-4cfd-bda3-0c01c7a89c0c" width=300 />
        </td>
        <td>
            <img src="https://github.com/user-attachments/assets/4585ab84-3294-4b44-b18f-7c7266ddb9b1" width=300 />
        </td>
    </tr>
    <tr>
        <td>
            <b>숏폼 디테일 정보 확인</b>
        </td>
        <td>
            <b>요약했던 숏폼 검색하기</b>
        </td>
    </tr>
    <tr>
        <td>
            <img src="https://github.com/user-attachments/assets/fb6fa297-825b-4280-bcf8-aa9f89cbe36f" width=300 />
        </td>
        <td>
            <img src="https://github.com/user-attachments/assets/cb283284-1799-4891-a82a-5762faf6ff9a" width=300 />
        </td>
    </tr>
</table>
    



# Tech features

## 클린 아키텍처

`Shortcap iOS`는 클린아키텍처를 사용하여 내부로직을 분리했습니다.

해당 서비스는 익스텐션 앱과 기본앱이 동일한 로직 및 저장소를 일정부분 공유합니다. 

클린아키텍처 기반으로 할당된 객체의 명확한 역할과 느슨한 결합을통해 두 개의 앱에서 같은 객체(혹은 같은 저장소)를 동일하게 사용할 수 있었습니다.

해당 부분의 경우 앱별 의존성주입코드를 포함하는 `Assembly객체`를 확인해 주시기 바랍니다.

<img src="https://github.com/user-attachments/assets/b778efae-d488-4e39-857f-826002940b18" width=500 />


### 클린아키텍처 기반 모듈 의존성 그래프
<img src="https://github.com/HongikGraduationProject/Frontend/blob/develop/Docs/ModuleDependency/graph.png" width=300>


## Debounce를 활용한 검색

`RxSwift`의 Debounce오퍼레이터를 활용하여 정해진 시간(500 miliseconds)동안 유저 입력이 없는 경우 숏폼 검색이 실행되도록 구현했습니다.

해당 구현을 통해 **유저가 일일히 검색 버튼을 누르지 않게** 하면서 **네트워크 대역폭에 줄 수 있는 영향을 최소화**하였습니다.

```swift
searchingText
    .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    .withUnretained(self)
    .subscribe { (viewModel, word) in
        
        viewModel.requestSearchResult(word: word)
    }
    .disposed(by: disposeBag)
```
