//
//  KeyboardObserver.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import Combine
import SwiftUI

/// Keyboard observer
final class KeyboardObserver: ObservableObject { // TODO: delete?
    /// Keyboard is visible
    @Published private(set) var isKeyboardVisible = false
    /// Current keyboard height
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    /// Keyboard height publisher
    var heightPublisher: AnyPublisher<CGFloat, Never> {
        $keyboardHeight
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()

    init() {
        let nc = NotificationCenter.default
        nc.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: nc.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] note in self?.handle(note) }
            .store(in: &bag)
    }
    
    private func handle(_ note: Notification) {
        guard let window = UIWindow.current,
              let info = note.userInfo,
              let endValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let kbEndOnScreen = endValue.cgRectValue
        let kbEndInWindow = window.convert(kbEndOnScreen, from: nil)
        
        // сколько клавиатура перекрывает низ окна
        let rawOverlap = max(0, window.bounds.maxY - kbEndInWindow.origin.y)
        
        // вычитаем нижний safe area у окна, чтобы не «удвоить» отступ
        let effectiveOverlap = max(0, rawOverlap - window.safeAreaInsets.bottom)
        
        DispatchQueue.main.async {
            self.isKeyboardVisible = effectiveOverlap > 0
            self.keyboardHeight = effectiveOverlap
        }
    }
    
}
