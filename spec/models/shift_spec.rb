require 'spec_helper'

describe Shift do
  # it "should decrement slots" do
  #   shift = Shift.new(start_date: "2013-11-04 06:00:00",
  #                     end_date: "2013-11-04 17:00:00",
  #                     manager_id:,
  #                     name:,
  #                     slots:,
  #                     max_slots: 
  #                    )
  # end
    
  
  describe "shift#requested?" do
    it "should determine if it has been requested" do
      shift = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test",
                        slots: 0,
                        max_slots: 2  
                       )
                     
      user = double("User")
      user.stub(:admin?).and_return(false)
    
      shift.stub(:employees).and_return([user])
    
      expect(shift.requested?(user)).to be(true)
                     
    end
  
    it "should not be requested by admin" do
      shift = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test",
                        slots: 0,
                        max_slots: 2  
                       )
                     
      user = double("User")
      user.stub(:admin?).and_return(true)
    
      shift.stub(:employees).and_return([user])
    
      expect(shift.requested?(user)).to be(false)
    end                 
  end
  
  describe "shift#request_status" do
    context "when shift is open" do
      it "should get availability status when user is admin" do
        shift = Shift.new(start_date: "2013-11-04 06:00:00",
                          end_date: "2013-11-04 17:00:00",
                          manager_id: 1,
                          name: "Test",
                          slots: 0,
                          max_slots: 2  
                         )
        user = double("User")
  
        user.stub(:admin?).and_return(true)             
        
        expect(shift.request_status(user)).to eq("available")

      end
      
      it "should get availability status when employee has requested a shift" do
        shift = Shift.new(start_date: "2013-11-04 06:00:00",
                          end_date: "2013-11-04 17:00:00",
                          manager_id: 1,
                          name: "Test",
                          slots: 0,
                          max_slots: 2  
                         )
        user = double("User")
        request = double("Request")
      
        request.stub(:status).and_return("pending")
        request.stub(:employee_id).and_return(2)
  
        user.stub(:admin?).and_return(false) 
        user.stub(:id).and_return(2)
                  
        shift.stub(:shift_requests).and_return([request])
      
       
        expect(shift.request_status(user)).to eq("pending")

      end
      
      it "should get availability status when employee has not requested a shift" do
        shift = Shift.new(start_date: "2013-11-04 06:00:00",
                          end_date: "2013-11-04 17:00:00",
                          manager_id: 1,
                          name: "Test",
                          slots: 0,
                          max_slots: 2  
                         )
        user = double("User")
        request = double("Request")
      
        request.stub(:status).and_return("available")
        request.stub(:employee_id).and_return(3)
  
        user.stub(:admin?).and_return(false) 
        user.stub(:id).and_return(2)
                  
        shift.stub(:shift_requests).and_return([request])
      
       
        expect(shift.request_status(user)).to eq("available")

      end
    end
       
    context "when shift is full" do
      
      it "should get availability status when user is admin" do
        shift = Shift.new(start_date: "2013-11-04 06:00:00",
                          end_date: "2013-11-04 17:00:00",
                          manager_id: 1,
                          name: "Test",
                          slots: 2,
                          max_slots: 2  
                         )
        user = double("User")
  
        user.stub(:admin?).and_return(true)             
        
        expect(shift.request_status(user)).to eq("full")

      end
    
      it "should get availability status when employee has not requested a shift" do
        shift = Shift.new(start_date: "2013-11-04 06:00:00",
                          end_date: "2013-11-04 17:00:00",
                          manager_id: 1,
                          name: "Test",
                          slots: 2,
                          max_slots: 2  
                         )
        user = double("User")
        request = double("Request")
    
        request.stub(:status).and_return("available")
        request.stub(:employee_id).and_return(3)

        user.stub(:admin?).and_return(false) 
        user.stub(:id).and_return(2)
                
        shift.stub(:shift_requests).and_return([request])
    
     
        expect(shift.request_status(user)).to eq("full")

      end
    
    end   
  end
  
  describe "shift#can_be_requested_by" do
    
    it "cannot be requested when user is admin" do
      shift = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test",
                        slots: 0,
                        max_slots: 2  
                       )
      user = double("User")
      
      user.stub(:admin?).and_return(true)
      
      expect(shift.can_be_requested_by?(user)).to be(false)
    end
    
    it "cannot be requested by user with different manager" do
      shift = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test",
                        slots: 0,
                        max_slots: 2  
                       )
      user = double("User")
      shift_request = double("ShiftRequest")
      
      shift_request.stub(:employee_id).and_return(2)
      
      shift.stub(:shift_requests).and_return([shift_request])
      shift.stub(:overlap?).and_return(false)
      
      user.stub(:admin?).and_return(false)
      user.stub(:manager_id).and_return(3)
      user.stub(:id).and_return(4)
      
      expect(shift.can_be_requested_by?(user)).to be(false)
    end
    
  end
  
  describe "shift#overlap?" do
    
    it "requested shift overlaps 1" do
      shift1 = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test 1",
                        slots: 0,
                        max_slots: 2  
                       )
                       
     shift2 = Shift.new(start_date: "2013-11-04 06:00:00",
                       end_date: "2013-11-04 17:00:00",
                       manager_id: 1,
                       name: "Test 2",
                       slots: 0,
                       max_slots: 2  
                      )                 
      user = double("User")
      
      user.stub(:working_shifts).and_return([shift1, shift2])
      
      expect(shift1.overlap?(user)).to be(true)
    end
    
    it "requested shift overlaps 2" do
      shift1 = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test 1",
                        slots: 0,
                        max_slots: 2  
                       )
                       
     shift2 = Shift.new(start_date: "2013-11-04 07:00:00",
                       end_date: "2013-11-04 13:00:00",
                       manager_id: 1,
                       name: "Test 2",
                       slots: 0,
                       max_slots: 2  
                      )                 
      user = double("User")
      
      user.stub(:working_shifts).and_return([shift1, shift2])
      
      expect(shift1.overlap?(user)).to be(true)
    end
    
    it "requested shift overlaps 3" do
      shift1 = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test 1",
                        slots: 0,
                        max_slots: 2  
                       )
                       
     shift2 = Shift.new(start_date: "2013-11-04 05:00:00",
                       end_date: "2013-11-04 13:00:00",
                       manager_id: 1,
                       name: "Test 2",
                       slots: 0,
                       max_slots: 2  
                      )                 
      user = double("User")
      
      user.stub(:working_shifts).and_return([shift1, shift2])
      
      expect(shift1.overlap?(user)).to be(true)
    end
    
    it "requested shift overlaps 4" do
      shift1 = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test 1",
                        slots: 0,
                        max_slots: 2  
                       )
                       
     shift2 = Shift.new(start_date: "2013-11-04 05:00:00",
                       end_date: "2013-11-04 18:00:00",
                       manager_id: 1,
                       name: "Test 2",
                       slots: 0,
                       max_slots: 2  
                      )                 
      user = double("User")
      
      user.stub(:working_shifts).and_return([shift1, shift2])
      
      expect(shift1.overlap?(user)).to be(true)
    end
    
    it "requested shift overlaps 5" do
      shift1 = Shift.new(start_date: "2013-11-04 06:00:00",
                        end_date: "2013-11-04 17:00:00",
                        manager_id: 1,
                        name: "Test 1",
                        slots: 0,
                        max_slots: 2  
                       )
                       
     shift2 = Shift.new(start_date: "2013-11-04 03:00:00",
                       end_date: "2013-11-04 18:00:00",
                       manager_id: 1,
                       name: "Test 2",
                       slots: 0,
                       max_slots: 2  
                      )                 
      user = double("User")
      
      user.stub(:working_shifts).and_return([shift1, shift2])
      
      expect(shift1.overlap?(user)).to be(true)
    end
    
  end
  
  it "should validate correct start and end date order" do
    shift = Shift.new(start_date: "2013-11-04 06:00:00",
                      end_date: "2013-11-04 17:00:00",
                      manager_id: 1,
                      name: "Test",
                      slots: 0,
                      max_slots: 2  
                     )
                                     
    expect(shift).to be_valid
  end
  
  it "should not validate incorrect start and end date order" do
    shift = Shift.new(start_date: "2013-11-04 17:00:00",
                      end_date: "2013-11-04 6:00:00",
                      manager_id: 1,
                      name: "Test",
                      slots: 0,
                      max_slots: 2  
                     )
                                     
    expect(shift).to_not be_valid
  end
end