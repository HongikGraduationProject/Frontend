![숏캡 썸네일](https://github.com/user-attachments/assets/4c40e92d-38a2-4363-bf7b-a5dd250b3514)

## About ShortCap

<table>
    <tr>
        <td><span>소속</span></td>
        <td><span>2024학년도 홍익대학교 컴퓨터공학과 창직종합설계프로젝트, IT 연합동아리 코테이토 9기</span></td>
    </tr>
    <tr>
        <td><span>개발기간</span></td>
        <td><span>2024.03 ~ 2024.11</span></td>
    </tr>
    <tr>
        <td><span>사용기술</span></td>
        <td><span>Swift, UIKit, RxSwift, MVVM-C</span></td>
    </tr>
</table>

💡 기존의 숏폼 플랫폼에서 제공하는 ‘저장하기’ 기능은 단순히 숏폼의 썸네일만을 나열하여 보여주며 분류, 검색과 같은 사용자 친화적인 기능을 제공하지 있지 않습니다.

이로 인해 사용자는 저장했던 영상 중 원하는 영상을 찾기 위해 무한정 스크롤을 내리며 영상들을 일일이 확인해야합니다.

이러한 불편함을 해소시켜주기 위해 사용자가 저장한 숏폼을 자동으로 요약 및 분류해주는 ‘숏폼 동영상 자동 요약 및 분류 앱’, `숏캡(ShortCap)`을 개발하게 되었습니다. 


## Application features

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
            <img src="https://github.com/user-attachments/assets/051340f5-1cfe-4fcf-89a4-80fe2dbddc78" width=300 />
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
    



# iOS tech features

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
