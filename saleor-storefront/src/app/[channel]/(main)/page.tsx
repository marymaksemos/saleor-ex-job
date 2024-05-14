import Image from "next/image";
import edjsHTML from "editorjs-html";
import xss from "xss";
import {
	FeaturedCollectionsDocument,
	ProductListByCollectionDocument,
	ProductListDocument,
} from "@/gql/graphql";
import { executeGraphQL } from "@/lib/graphql";
import { ProductList } from "@/ui/components/ProductList";
import { SideNavbar } from "@/ui/components/SideNavbar/SideNavbar";

import { cn } from "@/lib/utils";
import { Carousel, CarouselContent, CarouselItem } from "@/components/ui/carousel";

const parser = edjsHTML();

export const metadata = {
	title: "allistore",
	description: "allistore Store",
};

export default async function Page({ params }: { params: { channel: string } }) {
	const { collections: featuredCollections } = await executeGraphQL(FeaturedCollectionsDocument, {
		variables: {
			first: 5,
			channel: params.channel,
		},
		revalidate: 60,
	});

	const { collection: featuredProducts } = await executeGraphQL(ProductListByCollectionDocument, {
		variables: {
			slug: "featured-products",
			channel: params.channel,
		},
		revalidate: 60,
	});

	const { products: newProducts } = await executeGraphQL(ProductListDocument, {
		variables: {
			channel: params.channel,
		},
	});

	const splitFirstWord = (str: string) => {
		const words = str.split(" ");
		const firstWord = words.shift();
		const remainingWords = words.join(" ");
		return {
			first: firstWord,
			remaining: remainingWords,
		};
	};

	return (
		<>
			<Carousel
				role="list"
				opts={{
					align: "start",
					loop: true,
				}}
			>
				<CarouselContent>
					<CarouselItem className="relative min-h-[600px]">
						<div className="mx-auto h-full max-w-screen-2xl p-8">
							<div className="flex h-full flex-col items-center justify-center gap-8 text-center lg:w-1/2 lg:items-start lg:text-start">
								<h2 className="text-5xl font-extrabold">Modren Store for developer</h2>
								<p>
									How employees, surely the a said drops. Bathroom expected that systems let place. Her safely
									been little. Enterprises flows films it a fly the of wasn&apos;t designer the her thought.
									Enterprises flows films it a fly the of wasn&apos;t designer.
								</p>
							</div>
						</div>
						<Image
							className="-z-10 h-full w-full object-cover"
							fill
							priority
							src="https://bazaar.ui-lib.com/assets/images/headers/furniture-1.jpg"
							alt="backgroundImage"
						/>
					</CarouselItem>

					<CarouselItem className="relative min-h-[600px]">
						<div className="mx-auto h-full max-w-screen-2xl p-8">
							<div className="flex h-full flex-col items-center justify-center gap-8 text-center lg:w-1/2 lg:items-start lg:text-start">
								<h2 className="text-5xl font-extrabold">Modren Store for developer</h2>
								<p>
									How employees, surely the a said drops. Bathroom expected that systems let place. Her safely
									been little. Enterprises flows films it a fly the of wasn&apos;t designer the her thought.
									Enterprises flows films it a fly the of wasn&apos;t designer.
								</p>
							</div>
							<Image
								className="-z-10 h-full w-full object-cover"
								fill
								src="https://bazaar.ui-lib.com/assets/images/headers/furniture-1.jpg"
								alt="backgroundImage"
							/>
						</div>
					</CarouselItem>
				</CarouselContent>
			</Carousel>

			<div className="mx-auto flex max-w-screen-2xl items-start justify-start">
				<div className="sticky top-16 hidden min-w-[300px] p-4 lg:block">
					<SideNavbar
						className="font-sm col-span-2 border bg-white  p-4 shadow-sm"
						channel={params.channel}
					/>
				</div>
				<div className="w-[100% - 300px] space-y-12 overflow-hidden p-4">
					<div className="grid w-full grid-cols-1 gap-8 md:grid-cols-2">
						{featuredCollections?.edges.map(({ node }, index) => (
							<div
								key={node.id}
								className={cn(
									"flex flex-col-reverse items-center justify-center rounded-md border bg-white p-8 text-center shadow-lg 2xl:flex-row 2xl:text-start",
									{
										"!text-center sm:row-span-1 md:col-span-2 md:!flex-col-reverse 2xl:col-span-1 2xl:row-span-2":
											index === 2,
									},
								)}
							>
								<div>
									<h2 className="text-3xl font-semibold">
										<span className="text-orange-500">{splitFirstWord(node.name).first} </span>
										<span>{splitFirstWord(node.name).remaining}</span>
									</h2>

									{node.description && (
										<div className="prose text-gray-700">
											{parser.parse(JSON.parse(node.description) || []).map((content) => (
												<div key={content} dangerouslySetInnerHTML={{ __html: xss(content) }} />
											))}
										</div>
									)}
								</div>
								{node.backgroundImage && (
									<Image
										className="w-64"
										src={node.backgroundImage.url}
										alt={node.name}
										sizes={"512px"}
										height={256}
										width={256}
										priority={index < 2}
									/>
								)}
							</div>
						))}
					</div>
					<div>
						<h2 className="text-2xl text-gray-600">New Arrive Products</h2>
						<ProductList products={newProducts?.edges.map(({ node }) => node) || []} />
					</div>
					<div>
						<h2 className="text-2xl text-gray-600">Best Saller Products</h2>
						<ProductList products={newProducts?.edges.map(({ node }) => node) || []} />
					</div>
					<div>
						<h2 className="text-2xl text-gray-600">New Featured Products</h2>
						<ProductList products={featuredProducts?.products?.edges.map(({ node }) => node) || []} />
					</div>
				</div>
			</div>
		</>
	);
}
