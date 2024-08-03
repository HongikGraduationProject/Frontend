//
//  DeploymentSettings.swift
//  Packages
//
//  Created by 최준영 on 8/03/24.
//

import ProjectDescription

public enum DeploymentSettings {
    
    public static let deploymentVersion = DeploymentTargets.iOS("17.0")
    public static let bundleIdentifierPrefix = "com.hongtato.shortcap"
    public static let platform = Destinations.iOS
    public static let productName = "Shortcap"
}
