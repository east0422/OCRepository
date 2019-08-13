# 架构模式

#### MVC
1. 简述：MVC是一种设计思想，一种框架模式，是一种把应用中所有类组织起来的策略，它把程序分为三块：
	* M(Model)：实际上考虑的是"什么"问题，你的程序本质上是什么。独立于UI工作，是程序中用于处理应用程序逻辑的部分，通常负责存取数据。Controller和View都依赖Model层，Controller和View可以相互依赖。
	* C(Controller)：控制你Model如何呈现在屏幕上，当它需要数据的时候就告诉Model，你帮我获取某某数据；当它需要UI展示和更新的时候就告诉View，你帮我生成一个UI显示某某数据，是Model和View沟通的桥梁。View是把控制权交移给Controller, 自己不执行业务逻辑。Controller执行业务逻辑并且操作Model, 但不会直接操作View, 可以说对View是无知的。View和Model的同步消息都是通过观察者模式进行的，而同步操作是由View自己请求Model的数据然后对视图进行更新。
	* V(View)：Controller的手下，是Controller要使用的类，用于构建视图，通常是根据Model来创建视图的。用户对View操作以后，View捕获到这个操作，会把处理的权利交给Controller; Controller接着会执行相关的业务逻辑，这些业务逻辑可能需要对Model进行相应的操作；当Model变更以后会通过观察者模式通知View; View通过观察者模式收到Model变更消息以后会向Model请求最新的数据，然后重新更新界面。
2. 通信规则：
	* C -> M：可以直接单向通信。Controller需要将Model呈现给用户，因此需要知道模型的一切，还需要有同Model完全通信的能力，并且能任意使用Model的公共api。
	* C -> V：可以直接单向通信，Controller通过View来布局用户界面。
	* M -> V：永远不要直接通信。Model是独立于UI的，并不需要和View直接通信，View通过Controller获取Model数据。
	* V -> C：View不能对Controller知道的太多，因此要通过间接的方式通信。
		1. Target action： 首先Controller会给自己留一个target，再把配套的action交给View作为联系方式，那么View接收到某些变化时，View就会发送action给target从而达到通知的目的。这里View只需要发送action，并不需要知道Controller如何去执行方法；
		2. 代理：有时候View没有足够的逻辑去判断用户操作是否符合规范，他会把判断这些问题的权利委托给其他对象，他只需获得答案就行了，并不会管是谁给的答案。
		3. DataSource：View没有拥有他们所显示数据的权力，View只能向Controller请求数据进行显示，Controller则获取Model的数据整理排版后提供给View。
	* M -> C：同样的Model是独立于UI存在的，因此无法直接与Controller通信，但是当Model本身信息发生了改变的时候，会通过下面的方式进行间接通信。
		1. Notification & KVO： 一种类似电台的方法，Model信息改变时会广播消息给感兴趣的人，只要Controller接收到了这个广播的时候就会主动联系Model，获取新的数据并提供给View。
3. 优点：
	* 低耦合性。
	* 有利于开发分工。
	* 有利于组件重用。
	* 可维护性。
	* 把业务逻辑全部分离到Controller中，模块化程度高。当业务逻辑变更的时候，不需要变更View和Model，只需要Controller换成另一个Controller就行了。观察者模式可以做到多视图同事更新。

#### MVP
1. MVP模式把MVC模式中的Controller换成了Presenter，View不再依赖Model层，其他依赖关系和MVC一致。
2. 用户对View的操作都会从View交移给Presenter。Presenter同样的会执行相应的业务逻辑，并且对Model进行相应的操作；而这时候Model通过观察者模式把自己变更的消息传给Presenter, Presenter获取到Model变更的消息以后通过View提供的接口更新界面。
3. View不再负责同步的逻辑，而是由Presenter负责。Presenter中既有业务逻辑也有同步逻辑。View需要提供操作界面的接口给Presenter进行调用。
4. 便于测试，View也可以进行组件化。不过Presenter中除了业务逻辑以外，还有大量的View->Model, Model->View的手动同步逻辑，造成Presenter比较笨重，维护起来比较困难。

#### MVVM
1. MVVM可以看作是一种特殊的MVP模式，或者说是对MVP模式的一种改良。MVVM的依赖关系和MVP一致，只不过是把P换成了VM。
2. 可维护性更高，解决了MVP大量手动View和Model同步的问题，提供双向绑定机制。简化测试，因为同步逻辑是交由Binder做的，View跟着Model同时变更，所以只需要保证Model的正确性，View就正确。
3. 不过对于简单的图形界面不太适用(牛刀杀鸡)。对于大型的图形应用程序，视图状态较多，ViewModel的构建和维护成本会比较高。数据绑定的声明是指令式地写在View的模版当中的，这些内容是没办法断点调试的。

