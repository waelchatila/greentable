require 'test_helper'

class GreentableTest < ActiveSupport::TestCase
  def capture(&block)
    yield
  end

  test "empty" do
    gt = Greentable::Table.new(self,[], {})
    gt.process do |gt, x|
      gt.col('col0') do
        x
      end
    end
    assert_equal "", gt.to_s
  end

  test "simple_2cols" do
    gt = Greentable::Table.new(self,[0, 1], {})
    gt.process do |gt, x|
      gt.col('col0') do
        x
      end
      gt.col('col1') do
        x
      end
    end
    assert_equal "<table><thead><tr><th>col0</th><th>col1</th></tr></thead><tbody><tr><td>0</td><td>0</td></tr><tr><td>1</td><td>1</td></tr></tbody></table>", gt.to_s
  end

  test "table_opts" do
    gt = Greentable::Table.new(self,[0], :class => 'table_class')
    gt.process do |gt, x|
      gt.col('col0', :th => {:class => 'th_class'}) do
        x
      end
      gt.col('col1', :td => {:class => 'td_class'}) do
        x
      end
    end
    assert_equal '<table class="table_class"><thead><tr><th class="th_class">col0</th><th>col1</th></tr></thead><tbody><tr><td>0</td><td class="td_class">0</td></tr></tbody></table>', gt.to_s
  end


  test "td_opts" do
    gt = Greentable::Table.new(self,[0], {})
    gt.process do |gt, x|
      gt.col('col0', :class => 'a', :td => {:class => 'aa'}) do
        x
      end
    end
    assert_equal '<table><thead><tr><th class="a">col0</th></tr></thead><tbody><tr><td class="a aa">0</td></tr></tbody></table>', gt.to_s
  end

  test "th_opts" do
    gt = Greentable::Table.new(self,[0], {})
    gt.process do |gt, x|
      gt.col('col0', :class => 'a', :th => {:class => 'aa'}) do
        x
      end
    end
    assert_equal '<table><thead><tr><th class="a aa">col0</th></tr></thead><tbody><tr><td class="a">0</td></tr></tbody></table>', gt.to_s
  end

  test "proc" do
    gt = Greentable::Table.new(self,[0], {})
    gt.process do |gt, x|
      gt.col(Proc.new{'proc0'}, :class => Proc.new{'proc1'}, :td => {:style => Proc.new{'proc2'}}) do
        x
      end
    end
    assert_equal '<table><thead><tr><th class="proc1">proc0</th></tr></thead><tbody><tr><td style="proc2" class="proc1">0</td></tr></tbody></table>', gt.to_s
  end

  test "table_opts_comprehensive" do
    gt = Greentable::Table.new(self,[0], :class => 'a aa', :style => 'b:c', :tr => {:class => 'd'}, :th => {:onclick => 'e();', :class => 'ee'}, :td => {'data-target' => 'f', :class => 'ff'})
    gt.process do |gt, x|
      gt.col('col0', :class => 'h', :th => {:class => 'i'}) do
        x
      end
      gt.col('col1', :td => {:class => 'j'}) do
        x
      end
    end
    assert_equal '<table class="a aa" style="b:c"><thead><tr class="d"><th onclick="e();" class="h i ee">col0</th><th onclick="e();" class="ee">col1</th></tr></thead><tbody><tr class="d"><td data-target="f" class="h ff">0</td><td data-target="f" class="j ff">0</td></tr></tbody></table>', gt.to_s
  end
end
