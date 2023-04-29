//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Liam Potts on 4/2/23.
//

import SwiftUI
import Firebase

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @State var postedByThisUser = false
    @State var rateOrReviewerString = "Click to rate:"
    @StateObject var reviewVM = ReviewViewModel()
    @Environment (\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack{
            VStack (alignment: .leading){
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                Text(spot.address)
                    .padding(.bottom)
            }
            
            Text(rateOrReviewerString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            HStack{
                StarsSelectionView(rating: $review.rating)
                    .disabled(!postedByThisUser)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                    }
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Review Title: ")
                    .bold()
                
                TextField("title", text: $review.title)
                    .padding(.horizontal, 6)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
                
                Text("Review")
                    .bold()
                
                TextField("reivew", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
            }
            .disabled(!postedByThisUser)
            .padding(.horizontal)
            .font(.title2)
        }
        
        .onAppear{
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewerString = "by: \(review.reviewer) on: \(reviewPostedOn)"
            }
        }
        .navigationBarBackButtonHidden(postedByThisUser)
        .toolbar{
            if postedByThisUser {
                ToolbarItem( placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem( placement: .navigationBarTrailing) {
                    Button("Save"){
                        Task{
                            let success = await reviewVM.saveReview(spot: spot, review: review)
                            if success{
                                dismiss()
                            } else {
                                print("😡 ERROR saving data in ReviewView")
                            }
                            
                        }
                        
                    }
                }
                
                if review.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task {
                                let success = await reviewVM.deleteReview(spot: spot, review: review)
                                if success {
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
 
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boyleston St. Chestnut Hill, MA 02467"), review: Review())
        }
    }
}
