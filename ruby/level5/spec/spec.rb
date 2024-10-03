require_relative '../main'
require 'json'

describe 'Level 5 - Rental Pricing' do
  it 'generates the expected output' do
    input_file_path = File.join(__dir__, '..', 'data', 'input.json')
    output_file_path = File.join(__dir__, '..', 'data', 'output.json')
    expected_output_file_path = File.join(__dir__, '..', 'data', 'expected_output.json')

    generate_output(input_file_path, output_file_path)

    output = JSON.parse(File.read(output_file_path))
    expected_output = JSON.parse(File.read(expected_output_file_path))

    expect(output).to eq(expected_output)
  end
end
