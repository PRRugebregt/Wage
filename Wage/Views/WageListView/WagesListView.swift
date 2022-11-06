//
//  WagesListView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI
import CocoaLumberjackSwift

struct WagesListView: View {
    
    typealias Dependencies = HasFiltering & HasWageFileLoader
    
    @ObservedObject var wageFileLoader: WageFileLoader
    @Binding var isShowingHelpScreen: Bool
    @State var orientation: UIDeviceOrientation?
    @State private var showFilters: Bool = false
    @State private var showList: Bool  = false
    @State var onlineResults: Bool = false {
        didSet {
            DDLogInfo("Toggle switch")
            wageFileLoader.isLocal.toggle()
        }
    }
    
    private var dependencies: Dependencies
    private var filtering: Filtering
    private var wageFiles : [WageFile] {
        wageFileLoader.wageFiles
    }
    
    init(dependencies: Dependencies, showInitialHelpView: Binding<Bool>) {
        self.dependencies = dependencies
        self.wageFileLoader = dependencies.injectWageFileLoader()
        self.filtering = dependencies.injectFiltering()
        self._isShowingHelpScreen = showInitialHelpView
    }
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                TopWageListView(dependencies: dependencies, showFilters: $showFilters, showList: $showList)
                    .blur(radius: 0)
                if wageFiles.isEmpty {
                    WageFileEmptyView(isShowingHelpScreen: $isShowingHelpScreen)
                } else {
                    ScrollViewReader{ proxy in
                        List {
                            ForEach(wageFiles) { item in
                                PrettyCell(item: item, size: geometry.size)
                            }
                            .onDelete { index in
                                wageFileLoader.deleteWageFile(with: index)
                            }
                        }
                        .transition(.scale)
                        .blur(radius: isShowingHelpScreen ? 5 : 0)
                    }
                }
            }
            .transition(.scale)
            .animation(Animation.easeInOut(duration: 1), value: showList)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .listStyle(.inset)
            .opacity(0.7)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
            .refreshable {
                showList.toggle()
                Task {
                    await wageFileLoader.loadAllFiles()
                }
            }
        }
    }
}

struct TopWageListView: View {
    
    typealias Dependencies = HasFiltering & HasWageFileLoader
    
    var dependencies: Dependencies
    var filtering: Filtering
    @ObservedObject var wageFileLoader: WageFileLoader
    @State var chosenSortOption: SortOptions?
    @State var onlineResults: Bool = false
    @State var didTap: Bool = false
    @Binding var showFilters: Bool
    @Binding var showList: Bool
    
    init(dependencies: Dependencies, showFilters: Binding<Bool>, showList: Binding<Bool>) {
        self.dependencies = dependencies
        self._showFilters = showFilters
        self._showList = showList
        self.filtering = dependencies.injectFiltering()
        wageFileLoader = dependencies.injectWageFileLoader()
    }

    var body: some View {
        HStack {
            Menu(content: {
                ForEach(SortOptions.allCases) { sortOption in
                    Button {
                        showList.toggle()
                        wageFileLoader.sortFiles(by: sortOption)
                        chosenSortOption = sortOption
                    } label: {
                        HStack {
                            if sortOption == chosenSortOption {
                                Image(systemName: "checkmark")
                            }
                            Text(sortOption.rawValue).fontWeight(.light).font(.body)
                        }
                    }
                }
            }, label: {
                HStack {
                    Text("Sorteer").fontWeight(.light).font(.body)
                    Image(systemName: "chevron.down").font(.subheadline)
                }
            })
            .frame(maxWidth: .infinity)
            .foregroundColor(.blue)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            if !filtering.isFiltered {
                isNotFilteredView()
            } else {
                isFilteredView()
            }
            Toggle("", isOn: $onlineResults)
            .labelsHidden()
            .frame(maxWidth: .infinity).offset(x: -18)
            .toggleStyle(CustomToggleStyle())
            .padding(.horizontal)
            .padding(.vertical, 5)
            .onChange(of: onlineResults) { newValue in
                showList.toggle()
                wageFileLoader.isLocal = !onlineResults
            }
        }
    }
    
    @ViewBuilder
    private func isNotFilteredView() -> some View {
        VStack {
            Button {
                showList.toggle()
                showFilters.toggle()
            } label: {
                HStack {
                    Group {
                    Text("Filter")
                        .fontWeight(.light)
                        .font(.body)
                        Image("filter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(3)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 25)
            .foregroundColor(didTap ? .gray : .blue)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .onTapGesture(perform: {
                didTap = true
            })
            .sheet(isPresented: $showFilters, onDismiss: {
                wageFileLoader.setFilterOptions(with: filtering.filterOptions)
                Task {
                    await wageFileLoader.loadAllFiles()
                }
                
            }) {
                FilterView(dependencies: dependencies, isPresented: $showFilters)
            }
        }
    }
    
    private func isFilteredView() -> some View {
        Button() {
            showList.toggle()
            filtering.reset()
        } label: {
            HStack {
                Text("Filters").fontWeight(.light).font(.body)
                Image(systemName: "x.square").font(.title2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 25)
        .foregroundColor(.red)
        .shadow(color: .gray, radius: 3, x: 0, y: 3)
        .opacity(filtering.isFiltered ? 1 : 0)
    }
    
}

struct WageFileEmptyView: View {
    
    @Binding var isShowingHelpScreen: Bool
    @State var scale: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(systemName: "eyes").font(.largeTitle)
            Divider()
            Text("De lijst is leeg. Voeg gages toe (+) of bekijk de online resultaten")
                .blur(radius: isShowingHelpScreen ? 5 : 0)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .scaleEffect(scale)
        .onAppear(perform: { scale += 1 })
        .animation(Animation.spring(), value: scale)
    }
}

struct BindingViewExamplePreviewContainer_2 : View {
     @State
     private var value = false

     var body: some View {
         WagesListView(dependencies: Dependencies(), showInitialHelpView: $value)
     }
}

struct WagesListView_Previews: PreviewProvider {
    
    @State var bindingBool = true
    
    static var previews: some View {
        BindingViewExamplePreviewContainer_2()
            .previewInterfaceOrientation(.portrait)
        PrettyCell(item: WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums, timeStamp: Date.now), size: CGSize(width: 400, height: 100))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

