//
//  MapView.swift
//  Shortcap
//
//  Created by choijunios on 11/14/24.
//

import UIKit

import DSKit


import RxSwift
import NMapsMap

class SummaryMapView: UIView {
    
    let mapView: NMFNaverMapView = {
        let view = NMFNaverMapView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let locationTitleLabel: CapLabel = {
        let label: CapLabel = .init()
        label.typographyStyle = .baseMedium
        return label
    }()
    
    let addressLabel: CapLabel = {
        let label: CapLabel = .init()
        label.typographyStyle = .smallMedium
        label.attrTextColor = DSColors.gray1.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setAppearance()
        setLayout()
        setObservable()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setAppearance() {
        backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        
        let labelStack = VStack([
            locationTitleLabel,
            addressLabel
        ], spacing: 5, alignment: .leading)
        
        [
            mapView,
            labelStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            labelStack.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -15),
            labelStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
        ])
    }
    
    private func setObservable() { }

    func setMap(name: String, address: String, lat: Double, lon: Double) {
        
        locationTitleLabel.text = name
        addressLabel.text = address
        
        // - 제스처 끄기
        mapView.mapView.isScrollGestureEnabled = false
        mapView.mapView.isZoomGestureEnabled = false
        mapView.mapView.isTiltGestureEnabled = false
        mapView.mapView.isRotateGestureEnabled = false
        mapView.mapView.isStopGestureEnabled = false
        
        // 지도 뷰 Config
        mapView.showCompass = false
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        mapView.showLocationButton = false
        
        
        let mapView = self.mapView.mapView
        
        
        // 마커 아이콘 사이즈
        let markerSize: CGSize = .init(width: 33, height: 44)
        
        // 마커 설정
        let locationPos: NMGLatLng = .init(lat: lat, lng: lon)
        
        var workerMarker: NMFMarker = .init(position: locationPos)
        workerMarker.width = 33
        workerMarker.height = 44
        
        workerMarker.mapView = mapView
        workerMarker.globalZIndex = 40001
        workerMarker.anchor = .init(x: 0.5, y: 1)
        
        
        // 카메라 이동
        let camerUpdate = NMFCameraUpdate(position: .init(locationPos, zoom: 10))
        mapView.moveCamera(camerUpdate)
        
        
        // 지도 Config
        mapView.mapType = .basic
        mapView.symbolScale = 2
    }
}
