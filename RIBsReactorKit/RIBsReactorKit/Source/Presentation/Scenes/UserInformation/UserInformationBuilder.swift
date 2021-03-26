//
//  UserInformationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserInformationDependency: Dependency {
  var userModelStream: UserModelStream { get }
}

final class UserInformationComponent: Component<UserInformationDependency> {

  fileprivate var userModelStream: UserModelStream {
    dependency.userModelStream
  }

  fileprivate var initialState: UserInformationPresentableState {
    UserInformationPresentableState()
  }

  private var userInformationSectionFactories: [UserInfoSectionFactory] {
    [ProfileSectionFactory(), BasicInfoSectionFactory()]
  }

  fileprivate var userInformationSectionListFactory: UserInfoSectionListFactory {
    UserInfoSectionListFactoryImpl(factories: userInformationSectionFactories)
  }
}

// MARK: - Builder

protocol UserInformationBuildable: Buildable {
  func build(withListener listener: UserInformationListener) -> UserInformationRouting
}

final class UserInformationBuilder:
  Builder<UserInformationDependency>,
  UserInformationBuildable
{

  func build(withListener listener: UserInformationListener) -> UserInformationRouting {
    let component = UserInformationComponent(dependency: dependency)
    let viewController = UserInformationViewController()
    let interactor = UserInformationInteractor(
      initialState: component.initialState,
      userModelStream: component.userModelStream,
      userInformationSectionListFactory: component.userInformationSectionListFactory,
      presenter: viewController
    )
    interactor.listener = listener
    return UserInformationRouter(interactor: interactor, viewController: viewController)
  }
}
