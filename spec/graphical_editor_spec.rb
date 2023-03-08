# frozen_string_literal: true

require 'rspec'

require 'graphical_editor'

RSpec.describe GraphicalEditor do
  describe "#run_command" do
    let(:editor) { GraphicalEditor.new(5, 6) }

    context "when the command is I" do
      describe "and the M is 5 and N is 6" do
        let(:command) { "I 5 6" }

        it "creates a new 5 x 6 image with all pixels colored white" do
          editor.run_command(command)

          expect(editor.display).to eq("OOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO")
        end
      end

      describe "and the M is 1 and N is 10" do
        let(:command) { "I 1 10" }

        it "creates a new 1 x 10 image with all pixels colored white" do
          editor.run_command(command)

          expect(editor.display).to eq("O\nO\nO\nO\nO\nO\nO\nO\nO\nO")
        end
      end
    end

    context "when the command is C" do
      context "and the image is empty" do
        it "clears a cleared image" do
          editor.run_command("C")

          expect(editor.display).to eq("OOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO")
        end
      end

      context "and the image is not empty" do
        before {
          editor.run_command("I 5 6")
                .run_command("L 2 3 A")
        }

        it "clears the image" do
          editor.run_command("C")

          expect(editor.display).to eq("OOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO")
        end
      end
    end

    context "when the command is L" do
      before { editor.run_command("I 5 6") }

      it "colors the pixel (X,Y) with color C" do
        editor.run_command("L 2 3 A")

        expect(editor.display).to eq("OOOOO\nOOOOO\nOAOOO\nOOOOO\nOOOOO\nOOOOO")
      end
    end

    context "when the command is V" do
      before { editor.run_command("I 5 6") }

      it "draws a vertical segment of color C in column X between rows Y1 and Y2 (inclusive)" do
        editor.run_command("V 2 3 4 W")

        expect(editor.display).to eq("OOOOO\nOOOOO\nOWOOO\nOWOOO\nOOOOO\nOOOOO")
      end
    end

    context "when the command is H" do
      before { editor.run_command("I 5 6") }

      it "draws a horizontal segment of color C in row Y between columns X1 and X2 (inclusive)" do
        editor.run_command("H 3 4 2 Z")
        expect(editor.display).to eq("OOOOO\nOOZZO\nOOOOO\nOOOOO\nOOOOO\nOOOOO")
      end
    end

    context "when the command is F" do
      context "when the entire image is R" do
        before(:each) do
          # Paint the entire image with color R
          (1..5).each do |i|
            editor.run_command("V #{i} 1 6 R")
          end
        end

        it "fills the entire image with color C" do
          editor.run_command("F 1 1 C")
          expect(editor.display).to eq("CCCCC\nCCCCC\nCCCCC\nCCCCC\nCCCCC\nCCCCC")
        end
      end

      context "when only one pixel is R" do
        before(:each) do
          editor.run_command("L 1 1 R")
        end

        it "fills that pixel with C" do
          editor.run_command("F 1 1 C")
          expect(editor.display).to eq("COOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO\nOOOOO")
        end

        it "fills all other pixels with C" do
          editor.run_command("F 1 2 C")
          expect(editor.display).to eq("RCCCC\nCCCCC\nCCCCC\nCCCCC\nCCCCC\nCCCCC")
        end
      end
    end
  end
end
