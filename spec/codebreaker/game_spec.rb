require 'spec_helper'
 
module Codebreaker
  describe Game do
    let(:output) { double('output').as_null_object }
    let(:input)  { double('input').as_null_object }
    let(:game)   { Game.new(output, input) }
    let(:file)   { double('file').as_null_object }

    context "#start" do
      before do
        input.stub(:gets).and_return("1236")
      end

      after do
        game.start
      end
 
      it "sends a welcome message" do
        expect(output).to receive(:puts).with('Welcome to Codebreaker!')
      end
 
      it "prompts for the first guess" do
        expect(output).to receive(:puts).with('Enter guess:')
      end
    end

    context "#generate_code" do
      it "generate valid code" do
        game.code = ""
        game.send(:generate_code, 4)
        expect(game.code).to match(/^[1-6]{4}$/)
      end
    end

    context "#hint" do
      it "has correct hint" do
        game.code = "1234"
        hint = game.send(:hint)
        number = (hint =~ /^[1-6]$/)
        expect(game.code).to include(number.to_s)
      end
    end

    context "#check" do
      it "correctly compares the guess with code" do
        game.code = "1234"
        expect(game.send(:check, "1466")).to eq("+-")
      end
    end

    context "#result" do
      it "sends triumphant message" do
        expect(output).to receive(:puts).with("Codebreaker you win!")
        game.send(:result, true)
      end

      it "sends losing message" do
        expect(output).to receive(:puts).with("Codebreaker you lose! Secret code - #{game.code}")
        game.send(:result, false)
      end

      it "sends message of count attemps" do
        game.attemps = 7
        expect(output).to receive(:puts).with("You have used #{game.attemps} attemps")
        game.send(:result, true)
      end
    end

    context "#save_to_file" do
      it "saves information about the game to file" do
        game.attemps = 7
        expect(File).to receive(:open).with("test.txt", "a+").and_yield(file)
        expect(file).to receive(:write).with("Stas victory:'true' with attemps - 7")
        game.send(:save_to_file, "Stas", true) 
      end
    end
  end
end