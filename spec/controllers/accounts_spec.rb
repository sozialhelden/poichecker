# require 'spec_helper'
#
# describe AccountsController do
#   login_admin
#
#   let(:user) { mock_model(AdminUser) }
#
#   before do
#     expect(controller).to receive(:current_admin_user).and_return user
#     expect(controller).to receive(:authenticate_user!).and_return true
#   end
#
#   context '#index & #show' do
#     after do
#       expect(response).to redirect_to action: :edit, id: user.id
#     end
#
#     it 'should redirect to #edit' do
#       get :index
#     end
#
#     it 'should redirect to #edit' do
#       get :show, id: user.id
#     end
#   end
# end