[![Build Status](https://travis-ci.org/waelchatila/greentable.svg?branch=master)](https://travis-ci.org/waelchatila/greentable)
[![Coverage Status](https://coveralls.io/repos/waelchatila/greentable/badge.png?branch=master)](https://coveralls.io/r/waelchatila/greentable?branch=master)
[![Gem Version](https://badge.fury.io/rb/greentable.png)](http://badge.fury.io/rb/greentable)
Greentable
==========
Greentable produces HTML tables from an array without you having to deal with any HTML elements.
Greentable is an declarative approach to HTML tables and adds additional export features.

## Installation
```ruby
gem 'greentable'
```

Greentable works for Rails 3.x and Rails 4.x

## Usage
To produce a table from an array of elements, do the following in a view:

```haml
=greentable(users) do |gt,user|
  - gt.col('NAME') do
    =user.name
  - gt.col('EMAIL') do
    =user.email
```

which will produce the following html:

```html
<table>
    <thead>
        <tr>
          <th>NAME</th>
          <th>EMAIL</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Joe Ruby</td>
            <td>jruby@example.com</td>
        </tr>
        <tr>
            <td>Donald Rails</td>
            <td>drails@example.com</td>
        </tr>
    </tbody>
</table>
```

## Options

Both greentable and greentable.col may be called with an optional hash

```haml
=greentable(array, class: 'table_class') do |gt, el|
  -gt.col('col0', th: {class: 'th_class'}) do
    =el.col0
  -gt.col('col1', td: {class: 'td_class'}) do
    =el.col1
```

will produce

```html
<table class="table_class"">
    <thead>
        <tr>
            <th class="th_class">col0</th>
            <th>col1</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>...</td>
            <td class="td_class">...</td>
        </tr>
    </tbody>
</table>
```

A comprehensive example:

*note how gt.col(class: 'h') below is applied to both TH and TD elements*

```haml
=greentable(array, class: 'a aa', style: 'b:c', tr: {class: 'd'}, th: {onclick: 'e();'}, td: {class: 'f', 'data-target' => 'g'} ) do |gt, el|
  -gt.col('col0', class: 'h', th: {class: 'i'}) do
    =el.col0
  -gt.col('col1', td: {class: 'j'}) do
    =el.col1
```

will produce

```html
<table class="a aa" style="b:c">
    <thead>
        <tr class="d">
            <th onclick="e();" class="ee h i">col0</th>
            <th onclick="e();" class="ee">col1</th>
        </tr>
    </thead>
    <tbody>
        <tr class="d">
            <td data-target="f" class="ff h">0</td>
            <td data-target="f" class="ff j">0</td>
        </tr>
    </tbody>
</table>
```

If you need column names or options to be dynamic, you can use procs:

```haml
=greentable(years) do |gt,year|
  -gt.col('Year') do
    =year.to_s
  -4.times do |week|
    -gt.col(Proc.new{ week % 2 == 0 ? 'An even week' : 'An odd week' }, td: {style: Proc.new{ year % 2 == 1 ? 'background-color:red' : nil }} ) do
      =week
```

will produce

```html
<table>
    <thead>
        <tr>
            <th>Year</th>
            <th>An even week</th>
            <th>An odd week</th>
            <th>An even week</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>2013</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
        </tr>
        <tr>
            <td>2014</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
        </tr>
        ...
    </tbody>
</table>
```

## Counter Object
Sometimes, you'll need to know what row you're currently on. For that purpose Greentable exposes a counter object:

```haml
=greentable([x,y,z]) do |gt, el|
  -gt.col('i') do
    =gt.counter.i
  -gt.col('first?') do
    =gt.counter.first?
  -gt.col('last?') do
    =gt.counter.last?
  -gt.col('odd?') do
    =gt.counter.odd?
  -gt.col('even?') do
    =gt.counter.even?
```

will produce

```html
<table>
    <thead>
        <tr>
            <th>i</th>
            <th>first?</th>
            <th>last?</th>
            <th>odd?</th>
            <th>even?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0</td>
            <td>true</td>
            <td>false</td>
            <td>true</td>
            <td>false</td>
        </tr>
        <tr>
            <td>1</td>
            <td>false</td>
            <td>false</td>
            <td>false</td>
            <td>true</td>
        </tr>
        <tr>
            <td>2</td>
            <td>false</td>
            <td>true</td>
            <td>true</td>
            <td>false</td>
        </tr>
    </tbody>
</table>
```


## Greentable Footer

Sometimes, you'll need to display a total (or whathaveyou) at the end:

```haml
=greentable(products) do |gt, product|
  -gt.footer(class: 'a', style: 'border-top: 2px solid black;', tr: {class: 'footer_tr_class'}) do |footer|
    -footer.col do
      Total
    -footer.col(style: 'font-weight: bold;') do
      $3.14

  -gt.col('name') do
    =product
  -gt.col('price') do
    =product.price
```

will produce

```html
<table>
    <thead>
        <tr>
            <th>name</th>
            <th>price</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>ProductA</td>
            <td>$2.11</td>
        </tr>
        <tr>
            <td>ProductB</td>
            <td>$1.03</td>
        </tr>
    </tbody>
    <tfoot>
        <tr class='footer_tr_class'>
            <td class='a' style='border-top: 2px solid black;'>Total</td>
            <td class='a' style='border-top: 2px solid black; font-weight: bold;'>$3.14</td>
        </tr>
    </tfoot>
</table>
```

Subtotal, shipping, tax, total? No problem:

```haml
=greentable(order.order_line_items) do |gt, order_line_item|
  -gt.footer([:subtotal, :shipping, :tax, :total], class: 'klass') do |footer, attr|
    -footer.col do
      =attr
    -footer.col do
      =order.send(attr)

  -gt.col('name') do
    =order_line_item.name
  -gt.col('price') do
    =order_line_item.price
```

will produce

```html
<table>
    <thead>
        <tr>
            <th>name</th>
            <th>price</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>ProductA</td>
            <td>$2.11</td>
        </tr>
        <tr>
            <td>ProductB</td>
            <td>$1.03</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td class='klass'>subtotal</td>
            <td class='klass'>xyz</td>
        </tr>
        <tr>
            <td class='klass'>shipping</td>
            <td class='klass'>xyz</td>
        </tr>
        <tr>
            <td class='klass'>tax</td>
            <td class='klass'>xyz</td>
        </tr>
        <tr>
            <td class='klass'>total</td>
            <td class='klass'>xyz</td>
        </tr>
    </tfoot>
</table>
```

## Global Defaults
You can configure global defaults for all your greentables.

In config/initializers/greentable.rb

```ruby
Greentable.configure do |config|
  config.defaults = {class: 'myTableClass', tr: {class: 'myTrClass'}, th: {style: 'cursor:pointer'}, td: {class: 'pi', onclick: 'alert(3.14159265359)'}}
end
```

and in some view:

```erb
<%= greentable([3.14]) do |gt,element| %>
    <%  gt.col('First Column') do %>
        <%= element %>
    <% end %>
<% end %>
```

will produce

```html
<table class='myTableClass'>
    <thead>
        <tr class='myTrClass'>
          <th style='cursor:pointer'>First Column</th>
        </tr>
    </thead>
    <tbody>
        <tr class='myTrClass'>
            <td class='pi' onclick='alert(3.14159265359)'>3.14</td>
        </tr>
    </tbody>
</table>
```

## Green Export &amp; Green Printing

Greentable enables you to export or print your greentable data for download in various formats seamlessly by a rack middleware.
Add a couple of http query parameters in your view and your done:

```erb
<a href="/?greentable_export=csv&greentable_id=greentable_id">Export CSV</a>
|
<a href="/?greentable_export=print&greentable_id=greentable_id">Print</a>

<%= greentable([0], :id => 'greentable_id') do |gt, el| %>
    <% gt.col('i') do %>
        <%= el %>
    <% end %>
    <% gt.col('i+1') do %>
        <%= el + 1 %>
    <% end %>
<% end %>
```

Green Export and Green Printing requires *Nokogiri* to be installed. Add 'nokogiri' as a gem dependency to your project if you want to use greentable's export or printing feature

### Available Query Parameters

* **greentable_id**=*any string* [REQUIRED]. A unique html tag id to tell the rack middleware which greentable to extract.
* **greentable_export**=**csv** | **print** [REQUIRED].
  **csv** will produce a CSV file. Headers will be the table headers. Colspans are honored (row spans are not).
  **print** will extract the green table by id and insert a javascript snippet to print the doc
  ```javascript
    window.onload = function() { window.focus(); window.print(); }
  ```
  Any css styling done within the html *HEAD* will remain. Anything within the *BODY* will be replaced with the greentable content.
* **greentable_export_filename**=*any string* [OPTIONAL]. *default: 'export.csv'*.
  Specifies the filename in the *Content-Disposition* header. Only used if *greentable_export=csv*




