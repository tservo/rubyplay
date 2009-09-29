#!/usr/bin/env ruby
#
# Model: Sister, Slipper
#
class Sister
	attr_accessor :name, :shoesize
end

class Slipper
	attr_accessor :type, :shoesize
end

#
# Controller
#
def checkShoeSize(sister, slipper)
	if sister.shoesize == slipper.shoesize
		puts sister.name + " left her " + slipper.type + " slipper at the ball."
	end 
end

#
# Model: instances of classes
#
stepsister1          = Sister.new
stepsister1.name     = 'Anastasia'
stepsister1.shoesize = 7.5

stepsister2          = Sister.new
stepsister2.name     = 'Drizella'
stepsister2.shoesize = 7.0

ella             = Sister.new
ella.name        = 'Cinderella'
ella.shoesize    = 6.5

sisters = []
sisters << stepsister1
sisters << stepsister2
sisters << ella

glass_slipper          = Slipper.new
glass_slipper.type     = 'glass'
glass_slipper.shoesize = 6.5


#
# Controller
#
sisters.each { 
	|sis| checkShoeSize(sis, glass_slipper) 
}

# this is a comment
