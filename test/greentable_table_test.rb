require 'test_helper'

class GreentableTableTest < ActiveSupport::TestCase

  class String
    def html_safe
      self
    end
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

  test "global configuration" do
    Greentable.configure do |config|
      config.defaults = {class: 'table_class', tr: {class: 'tr_class'}, th: {class: 'th_class'}, td: {class: 'td_class'}}
    end
    begin
      gt = Greentable::Table.new(self,[0], {})
      gt.process do |gt, x|
        gt.col('col0') do
          x
        end
      end
      assert_equal "<table class=\"table_class\"><thead><tr class=\"tr_class\"><th class=\"th_class\">col0</th></tr></thead><tbody><tr class=\"tr_class\"><td class=\"td_class\">0</td></tr></tbody></table>", gt.to_s
    ensure
      Greentable.configure do |config|
        config.defaults = {}
      end
    end
  end

  test "footer - outside process" do
    gt = Greentable::Table.new(self,[1, 2], td: {class: 'a'})
    gt.footer(class: 'b', td: {class: 'c'}) do |footer|
      footer.col(colspan: 2) do
        'total'
      end
      footer.col do
        3
      end
    end
    gt.process do |gt, x|
      gt.col('name') do
        "name#{x}"
      end
      gt.col('price') do
        x
      end
    end
    assert_equal "<table><thead><tr><th>name</th><th>price</th></tr></thead><tbody><tr><td class=\"a\">name1</td><td class=\"a\">1</td></tr><tr><td class=\"a\">name2</td><td class=\"a\">2</td></tr></tbody><tfoot><tr><td class=\"a b c\" colspan=\"2\">total</td><td class=\"a b c\">3</td></tr></tfoot></table>", gt.to_s
  end

  test "footer - inside process" do
    gt = Greentable::Table.new(self, [0], {})
    gt.process do |gt, x|
      gt.footer do |footer|
        footer.col do
          'peace out'
        end
      end
      gt.col('col0') do
        x
      end
    end
    assert_equal "<table><thead><tr><th>col0</th></tr></thead><tbody><tr><td>0</td></tr></tbody><tfoot><tr><td class=\"\">peace out</td></tr></tfoot></table>", gt.to_s
  end

  test "row_counter" do
    gt = Greentable::Table.new(self, [0, 1, 2], {})
    gt.process do |gt, x|
      gt.col do
        case x
          when 0
            assert_equal "0", gt.counter.to_s
            assert_equal 0, gt.counter.i
            assert gt.counter.first?
            refute gt.counter.last?
            assert gt.counter.odd?
            refute gt.counter.even?
          when 1
            assert_equal "1", gt.counter.to_s
            assert_equal 1, gt.counter.i
            refute gt.counter.first?
            refute gt.counter.last?
            refute gt.counter.odd?
            assert gt.counter.even?
          when 2
            assert_equal "2", gt.counter.to_s
            assert_equal 2, gt.counter.i
            refute gt.counter.first?
            assert gt.counter.last?
            assert gt.counter.odd?
            refute gt.counter.even?
          else
            fail("should not come here. x=#{x}")
        end
      end
    end
  end
end
