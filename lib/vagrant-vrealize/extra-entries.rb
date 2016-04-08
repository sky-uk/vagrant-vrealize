# This class provides a little DSL for setting extra config entries
# in the Vagrantfile.
# It's used like so:
#
#   config.vm.provider :vrealize do |vrealize|
#     vrealize.add_entries do |extra_entries|
#       extra_entries.string "provider-MyCustomSetting", "myCustomValue"
#     end
#   end
#
class ExtraEntries

  LiteralTypes = %w{
    boolean
    decimal
    integer
    string
  }

  def initialize
    @entries = Hash.new(){|h,k| h[k] = {}}
  end

  # This block defines a setter for each LiteralType.
  # Use like this:
  #
  #   extra_entries.string "foo", "bar"
  #
  # then retrieve with
  #
  #   extra_entries.of_type("string") #=> [["foo", "bar"]]
  #
  LiteralTypes.each do |type|
    define_method(type.to_sym) do |key,value|
      @entries[type][key] = value
    end
  end

  def of_type(type)
    @entries[type] || []
  end

  def types
    @entries.keys
  end
end
