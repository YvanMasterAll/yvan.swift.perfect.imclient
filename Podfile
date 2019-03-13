platform :ios, '9.0'
use_frameworks!

targets = ['IMClient', 'IMClientTests', 'IMClientUITests']
targets.each do |t| 
	target t do
		pod 'SnapKit' 					#约束框架
		pod 'RxSwift'					#响应式框架
		pod 'RxCocoa'			
		pod 'RxDataSources'		
		pod 'Moya/RxSwift'				#网络层框架
		pod 'ObjectMapper'				#对象映射
		pod 'SwiftValidators' 			#验证框架
		pod 'Starscream' 				#网络通讯
		pod 'NVActivityIndicatorView' 	#加载图标
		pod 'WatchdogInspector' 		#FPS
		pod 'MLeaksFinder' 				#内存泄露
	end
end